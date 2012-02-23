# A collection of useful and tested git hooks
## Installation

Grab the hook file from `/release` folder and drop in your .git/hooks folder in the git repo you want the hook to trigger. Make sure to turn on the executable flag on the hook files. E.g. `chmod +x .git/hooks/commit-msg`

You are encouraged to clone this repository first and test the hook yourself ;-) If things don't seem to work as expected, feel free to file an issue (Github Issue) under this project.

## Development

This repo serves as a framework to build more useful hooks. To build a hook

* Add an empty hook file in /hooks folder. Do something useful with it, preferably in Ruby. See Resources section to understand how hooks work and know if there is any parameter passed to the hook you're interested in.
* Refactor the code out, preferably into `lib/git_hooks.rb`. This GitHooks module will grow and change overtime to increase modularity and flexibility
* Add tests under /spec folder. We're experimenting the lightweight and powerful minitest instead of rspec test framework for this small project.
* To export stand-alone hook files, add the hook names in `.build` file, then run it. Then you'll find the generated files in `/release` folder. make sure your `hooks/some-hook` file only requires files in /lib folder (you can require other libraries in there). See `hooks/commit-msg` for an example.

## Resources

* http://progit.org/book/ch7-3.html
* http://book.git-scm.com/5_git_hooks.html


## TODO

* Allow build to take arguments. If no argument is passed, should build all files in /hooks folder
