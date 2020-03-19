# frozen_string_literal: true

require 'json'
require 'colorize'
require 'fileutils'

module Crat
  class Project
    def initialize(n, t)
      @name = n
      @template = JSON File.open(File.expand_path('~') + '/.crat/templates/' + t + '/template.json').read
      @static_files = Dir.entries(File.expand_path('~') + '/.crat/templates/' + t + '/static/').select { |e| e != '.' && e != '..' }
      @temp_dir = File.expand_path('~') + '/.crat/templates/' + t + '/'
      @root_dir = Dir.pwd + '/' + @name + '/'
    end

    def create
      system("npx create-react-app #{@name}")
      clean_dir
      make_folders
      make_files
      install_deps
    end

    def clean_dir
      dir = @root_dir + 'src'
      Dir.entries(dir).select { |e| e != '.' && e != '..' }.each { |e| `rm -rf #{dir + '/' + e}` }
    end

    def make_files
      @static_files.each do |sf|
        parts = sf.split('.')
        fname = parts[-2..-1].join('.')
        fdir = parts[0..-3].join('/')
        full_path = @root_dir + fdir + '/' + fname
        system("cp #{@temp_dir + 'static/' + sf} #{full_path}")
      end
    end

    def make_folders
      folders = @template['options']['folders']
      folders.each do |f|
        system("mkdir -p #{@root_dir + f['path']}")
      end
    end

    def install_deps
      system("cd #{@root_dir}")
      dnames = []
      deps = @template['options']['dependencies']
      deps.each do |d, v|
        dnames << if v == 'latest'
                    d
                  else
                    "#{d}@#{v}"
                  end
      end
      system("npm i s #{dnames.join(' ')}")
    end
  end
  class Template
    def initialize(t)
      @temp = t
      @dir = File.expand_path('~') + '/.crat/templates/'
    end

    def list_all
      i = 0
      entries = Dir.entries(@dir)
      printer = Printer.new
      printer.show_configs(entries, @dir)
    end

    def create
      entries = Dir.entries(@dir)
      dupe = true
      while dupe
        print 'Name of project (no symbols, spaces ok): '
        name = gets.chomp
        name = 'Sample Template' if name == ''
        fname = name.gsub(/\W/, '_').gsub('__', '_').downcase
        if entries.include? fname
          puts 'Name already taken'.red
          dupe = true
        else
          puts "Creating template in #{@dir + fname}".green
          dupe = false
        end
      end
      temp = {
        name: name,
        description: '',
        dependencies: {
          axios: 'latest'
        },
        folders: [
          { path: 'src/css' }
        ]
      }
      FileUtils.mkdir_p @dir + fname + '/static'
      tfile = File.open(@dir + fname + '/template.json', 'w+')
      json = JSON.pretty_generate(temp)
      tfile.puts(json)
    end
  end
  class Printer
    def initialize
      @a = {
        mh: '─',
        mv: '│',
        ltr: '┌',
        lbr: '└',
        rtr: '┐',
        rbr: '┘',
        crv: '├',
        clv: '┤',
        cth: '┴',
        cbh: '┬',
        fb: '█',
        dbh: '═'
      }
      @width = 80
    end

    def title(t)
      boxtop
      line(t, 'center')
      boxcenter
    end

    def show_configs(entries, base)
      title('Create-React-App Templator')
      line('Templates')
      boxcenter
      i = 0
      entries.each do |e|
        next unless (e != '.') && (e != '..')

        i += 1
        file = File.open(base + e + '/template.json')
        config = JSON file.read
        line("#{i}.) [SLUG: #{e}] #{config['name']}", 1, 'cyan')
        boxcenter_dash
        line(config['description'].to_s, 5, 'green')
        boxcenter_dash
        line('Dependencies', 5, 'white')
        c = 0
        begin
          config['options']['dependencies'].each do |k, v|
            c += 1
            last = false
            last = true if c == config['options']['dependencies'].keys.length
            line(li(k.to_s + ' => ' + v, 4, last), 1, 'yellow')
          end
        rescue StandardError
        end
        boxcenter_dbl
      end
      boxbottom
    end

    def boxtop
      bt = []
      bt << @a[:ltr]
      (@width - 2).times { bt << @a[:mh] }
      bt << @a[:rtr]
      puts bt.join()
    end

    def line(t, pos = 1, color = 'white')
      segs = t.scan(/.{1,76}/)
      segs.each do |s|
        ln = []
        ln << @a[:mv]

        lmarg = if pos == 'center'
                  (((@width - 2) - s.length) / 2).round
                else
                  pos
                end

        rmarg = (@width - 2) - s.length - lmarg
        lmarg.times { ln << ' ' }
        case color
        when 'yellow'
          s = s.yellow
        when 'green'
          s = s.green
        when 'red'
          s = s.red
        when 'cyan'
          s = s.cyan
        end
        ln << s
        rmarg.times { ln << ' ' }
        ln << @a[:mv]
        puts ln.join()
      end
    end

    def li(t, ind, last = false)
      item = []
      ind.times { item << ' ' }
      char = @a[:crv]
      char = @a[:lbr] if last
      item << char + ' ' + t
      item.join
    end

    def boxcenter
      bt = []
      bt << @a[:crv]
      (@width - 2).times { bt << @a[:mh] }
      bt << @a[:clv]
      puts bt.join()
    end

    def boxcenter_dash
      bt = []
      bt << @a[:crv]
      (@width - 2).times { bt << '-' }
      bt << @a[:clv]
      puts bt.join()
    end

    def boxcenter_dbl
      bt = []
      bt << '╞'
      (@width - 2).times { bt << @a[:dbh] }
      bt << '╡'
      puts bt.join()
    end

    def boxbottom
      bt = []
      bt << @a[:lbr]
      (@width - 2).times { bt << @a[:mh] }
      bt << @a[:rbr]
      puts bt.join()
    end
  end
end
