module DockTrucker
  module Store
    class Rsync
      attr_accessor :origin_path, :rsync_options, :rsync_dest_path

      def initialize(rsync_options: ENV['RSYNC_OPTIONS'], rsync_dest_path: ENV['RSYNC_DEST_PATH'])
        self.rsync_options = rsync_options
        self.rsync_dest_path = rsync_dest_path
      end

      def sync
        rsync_options ||= '-azrL --delete'
        `rsync #{rsync_options} #{origin_path} #{rsync_dest_path}`
      end
    end
  end
end
