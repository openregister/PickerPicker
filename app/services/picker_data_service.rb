require 'open3'

class PickerDataService
  def generate(registerUri, fieldName)
    captured_stdout = ''
    captured_stderr = ''

    commands = "scripts/test.sh " + registerUri + " " + fieldName;
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

    return "stdout: " + captured_stdout + ", stderr: " + captured_stderr
  end
end
