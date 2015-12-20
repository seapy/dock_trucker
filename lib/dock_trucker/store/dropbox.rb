module DockTrucker
  module Store
    class Dropbox
      attr_accessor :origin_path, :dropbox_path
      
      COMMAND = File.expand_path("../../../bin/dropbox_uploader.sh", File.dirname(__FILE__))

      def initialize(dropbox_path: ENV['DROPBOX_PATH'])
        self.dropbox_path = dropbox_path
      end

      def delete
        files = `find #{origin_path} -mtime +#{Client::OLDFILE_PRESERVE_DAYS} -type f`.split
        files.each do |file|
          dropbox_file_path = file.sub(origin_path, '')
          `#{COMMAND} delete #{dropbox_path}#{dropbox_file_path}`
        end
      end

      def sync
        delete
        `#{COMMAND} mkdir #{dropbox_path}`
        `#{COMMAND} -s -f /root/.dropbox_uploader upload #{origin_path}/* #{dropbox_path}`
      end
    end
  end
end
