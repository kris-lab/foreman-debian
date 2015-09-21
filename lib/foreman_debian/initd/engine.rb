module ForemanDebian
  module Initd
    class Engine

      include ForemanDebian::EngineHelper

      def initialize(app, export_path = nil)
        @app = app
        @export_path = Pathname.new(export_path || '/etc/init.d')
        @system_export_path = Pathname.new('/etc/init.d')
        setup
      end

      def create_script(name, command, user)
        pidfile = pidfile(name)
        args = Shellwords.split(command)
        script = args.shift
        name = "#{@app}-#{name}"
        script_path = @export_path.join(name)
        Script.new(script_path, name, name, user, script, args, pidfile)
      end

      def install(script)
        FileUtils.mkdir_p(script.path.dirname)
        File.open(script.path, 'w') do |file|
          file.puts(script.render)
          file.chmod(0755)
          export_file(script.path)
        end
      end

      def start
        threads = []
        each_file do |path|
          threads << Thread.new do
            start_process(path)
            @output.info "  start  #{path.to_s}"
          end
          enable_start_process_on_boot(path)
        end
        ThreadsWait.all_waits(*threads)
      end

      def stop
        threads = []
        each_file do |path|
          @output.info "   stop  #{path.to_s}"
          threads << Thread.new do
            stop_process(path)
          end
          disable_start_process_on_boot(path)
        end
        ThreadsWait.all_waits(*threads)
      end

      def start_process(path)
        exec_command("#{path.to_s} start")
      end

      def stop_process(path)
        exec_command("#{path.to_s} stop")
      end

      def enable_start_process_on_boot(path)
        exec_command("update-rc.d #{path.basename} defaults") if path.dirname.eql? @system_export_path
      end

      def disable_start_process_on_boot(path)
        exec_command("update-rc.d -f #{path.basename} remove") if path.dirname.eql? @system_export_path
      end

      def remove_file(path)
        stop_process(path)
        disable_start_process_on_boot(path)
        super(path)
      end
    end
  end
end
