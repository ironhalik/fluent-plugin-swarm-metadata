#
# Copyright 2020- Michał Weinert
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "fluent/plugin/filter"

module Fluent
  module Plugin
    class SwarmMetadataFilter < Fluent::Plugin::Filter
      Fluent::Plugin.register_filter("swarm_metadata", self)

      config_param :docker_url, :string,  :default => 'unix:///var/run/docker.sock'
      config_param :cache_size, :integer, :default => 100
      config_param :container_id_regexp, :string, :default => '(\w{64})'
      config_param :fallback_key, :string, :default => 'unknown'

      def self.get_metadata(container_id)
        begin
          Docker::Container.get(container_id).info
        rescue Docker::Error::NotFoundError
          nil
        end
      end

      def configure(conf)
        super

        require 'docker'
        require 'lru_redux'

        Docker.url = @docker_url

        @cache = LruRedux::ThreadSafeCache.new(@cache_size)
        @container_id_regexp_compiled = Regexp.compile(@container_id_regexp)
      end

      def filter(tag, time, record)
        container_id = tag.match(@container_id_regexp_compiled)

        if container_id && container_id[0]
          container_id = container_id[0]
          metadata = @cache.getset(container_id){SwarmMetadataFilter.get_metadata(container_id)}

          record['swarm_namespace'] = metadata['Config']['Labels']['com.docker.stack.namespace'] || @fallback_key
          record['swarm_service_name'] = metadata['Config']['Labels']['com.docker.swarm.service.name'] || @fallback_key
          record['swarm_task_name'] = metadata['Config']['Labels']['com.docker.swarm.task.name'] || @fallback_key
        else
          record['swarm_namespace'] = @fallback_key
          record['swarm_service_name'] = @fallback_key
          record['swarm_task_name'] = @fallback_key
        end
        record
      end
    end
  end
end
