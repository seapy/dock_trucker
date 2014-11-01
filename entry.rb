require 'docker'
require 'awesome_print'

class Entry
  BACKUP_PATH = '/backup'
  S3_PATH = ENV['S3_PATH']
  OLDFILE_PRESERVE_DAYS = Integer(ENV['OLDFILE_PRESERVE_DAYS'] || 14)

  def initialize
    FileUtils.mkdir_p BACKUP_PATH

    @volumes = []
    volumes_froms.each do |v|
      @volumes << {
        v => volume_paths(v)
      }
    end
  end

  def backup
    @volumes.each do |volume|
      volume.each do |name, paths|
        paths.each do |path|
          tar(name, path)
        end
      end
    end
  end

  def vacuum
    `find #{BACKUP_PATH} -mtime +#{OLDFILE_PRESERVE_DAYS} -type f -delete`
  end

  def sync
    `aws s3 sync #{BACKUP_PATH} s3://#{S3_PATH} --delete`
  end

  private 
  def volumes_froms
    info = container_info(ENV['HOSTNAME'])
    info['HostConfig']['VolumesFrom']
  end

  def volume_paths(volumes_container_name)
    info = container_info(volumes_container_name)
    info['Volumes'].keys
  end

  def container_info(container_name)
    container = Docker::Container.get(container_name)
    container.info
  end

  def tar(name, path)
    remove_leading_path = path[1..-1]
    file_name = "#{remove_leading_path.gsub('/', '_')}-#{Time.new.strftime('%Y%m%d-%H%M')}"
    dir_path = "#{BACKUP_PATH}/#{name}"
    FileUtils.mkdir_p dir_path
    `tar cvf #{dir_path}/#{file_name}.tar -C / #{remove_leading_path}`
  end
end

entry = Entry.new
entry.backup
entry.vacuum
entry.sync