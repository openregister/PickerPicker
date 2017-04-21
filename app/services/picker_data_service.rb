require 'open3'
require 'rubygems'
require 'zip'

class PickerDataService
  def generate(registerName, registerUri, fieldName)
    captured_stdout = ''
    captured_stderr = ''

    # commands = "scripts/test.sh " + registerUri + " " + fieldName;
    commands = "curl "+ registerUri+ "/download-rsf | csi -s /Users/karlbaker/work/kibitz/register-simple-picker.scm "+ registerName +" "+ fieldName +" | csi -s /Users/karlbaker/work/kibitz/picker-input-to-json.scm"
    stdin, stdout, stderr, wait_thr = Open3.popen3(commands)

    pid = wait_thr.pid  # pid of the started process.

    stdin.close  # stdin, stdout and stderr should be closed explicitly in this form.

    captured_stdout = stdout.read
    captured_stderr = stderr.read

    stdout.close
    stderr.close
    exit_status = wait_thr.value  # Process::Status object returned.

    # path = Rails.root.join("app", "assets", "static", "picker-input.sample.json");
    # return File.read(path);

    path = Rails.root.join("app", "assets", "static", "picker-data.json")
    file = File.new(path, "w+");
    file.puts(captured_stdout)
    file.close

    # createZip()

    return captured_stdout
    # return "stdout: " + captured_stdout + ", stderr: " + captured_stderr
  end

  def createZip()
    filesToZip = [Rails.root.join("app", "assets", "static", "picker.html"), Rails.root.join("app", "assets", "static", "'picker-data.json'")]
    destination = Rails.root.join("app", "assets", "static", "code.zip")

    Zip::File.open(destination, Zip::File::CREATE) do |zipFile|
      filesToZip.each do |filename|
        zipFile.add(filename, destination)
      end
    end
  end
end
