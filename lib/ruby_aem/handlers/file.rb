=begin
Copyright 2016 Shine Solutions

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
=end

module RubyAem
  module Handlers

    def Handlers.file_download(data, status_code, headers, response_spec, info)

      FileUtils.cp(data.path, "#{info[:file_path]}/#{info[:package_name]}-#{info[:package_version]}.zip")
      data.delete

      message = response_spec['message'] % info

      RubyAem::Result.new('success', message)
    end

  end
end
