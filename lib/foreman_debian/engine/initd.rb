module ForemanDebian
  class Engine::Initd

    attr_accessor :app, :user

    def initialize(app, user, export_path = nil)
      @app = app
      @user = user
      @export_path = Pathname.new(export_path || '/etc/init.d')
      @exported = []
      @output = $stdout
    end

    def install(name, command)
      name = "#{@app}-#{name}"
      pidfile = Pathname.new('/var/run').join(name).join(name + '.pid')
      args = Shellwords.split(command)
      script = args.shift

      FileUtils.mkdir_p(@export_path)
      template = Template.new('initd_script')
      output = template.render({
                                   :name => name,
                                   :user => @user,
                                   :description => name,
                                   :script => script,
                                   :arguments => args,
                                   :pidfile => pidfile,
                               })
      script_path = @export_path.join(name)
      File.open(script_path, 'w') do | file|
        file.puts(output)
        file.chmod(0755)
        @exported.push(script_path)
        @output.puts " create  #{script_path.to_s} "
      end
    end

    def cleanup
      Dir.glob @export_path.join("#{app}-*") do |filename|
        filename = Pathname.new(filename)
        next unless filename.read.match(/# Autogenerated by foreman/)
        next if @exported.include? filename
        File.unlink filename
        @output.puts " remove  #{filename.to_s}"
      end
    end
  end
end
