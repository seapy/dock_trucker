module DockTrucker
  module Store
    class S3
      attr_accessor :origin_path, :store_path

      def initialize(store_path: ENV['S3_PATH'])
        self.store_path = store_path
      end

      def sync
        `aws s3 sync #{origin_path} s3://#{store_path} --delete`
      end
    end
  end
end
