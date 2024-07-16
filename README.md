# README

## Task.

Create a Rails application to show the results for TV SMS voting campaigns, derived from the log data similar to the attached tarball.

This task should take no more than two hours, and probably considerably less.

### Deliverables.

- A Rails application and associated database to hold the data.

- A basic web front-end to view the results which should...

    - Present a list of campaigns for which we have results.

    - When the User clicks on a Campaign, present a list of the candidates, their scores, and the number of messages which were sent in but not counted.

    - A command-line script that will import log file data into the application.

    - Any lines that are not well-formed should be discarded.
    
    - The sample data has been compressed to be emailed to you, but your script should assume the data is uncompressed plain text.

    - A description of your approach to this problem, including any significant design decisions and your reasoning in making your choices (this is the most important deliverable).

### Parsing Rules.

Here is an example log line...

```
VOTE 1168041980 Campaign:ssss_uk_01B Validity:during Choice:Tupele
CONN:MIG00VU MSISDN:00777778429999
GUID:A12F2CF1-FDD4-46D4-A582-AD58BAA05E19 Shortcode:63334
```

- All well-formed lines will have the same fields, in the same order.

    - They will all begin with 'VOTE', then have an `epoch` time value, then a set of fields with an identifier, a colon, and the value of the field.
    
    - E.g. 'Campaign:ssss_uk_01B'.

    - A Campaign is an episode of voting.

- Choice indicates the Candidate the User is voting for.

    - In every Campaign there will be a limited set of candidates that can be voted for.

    - If Choice is blank, it means the system could not identify the chosen Candidate from the text of the SMS message.
    
    - All such messages should be counted together as `errors`, irrespective of their Validity values.
    
    - There is a limited set of values for Choice, each of which represents a Candidate who can be voted for.

- Validity classifies the time when the Vote arrived, relative to the time window when votes will count towards a Candidate's score.

    - Only votes with a Validity of 'during' should count towards a Candidate's score.

    - Other possible values of Validity are 'pre' (message was too early to be counted), 'post' (message was too late to be counted).
    
    - 'pre' and 'post' messages should be counted together irrespective of the Candidate chosen.

- The 'CONN', 'MSISDN', 'Shortcode' and 'GUID' fields are not relevant to this exercise.

## Ruby Version.

```
2.7.0
```

## System Dependencies.

1. Homebrew.

    - The Missing Package Manager for macOS (or Linux).
        
        [Homebrew](https://brew.sh/)
        
2. `rbenv`.

    - `rbenv` is a version manager tool for the Ruby programming language on Unix-like systems.
        
        [GitHub - rbenv/rbenv: Manage your app's Ruby environment](https://github.com/rbenv/rbenv)
        
    - Install `rbenv`.
        
        ```bash
        brew install rbenv
        ```
        
    - Set up your shell to load `rbenv`.
        
        ```bash
        rbenv init
        ```
        
    - Close your Terminal window and open a new one so your changes take effect.

3. Ruby.

    - Rails requires Ruby version 2.7.0 or later. It is preferred to use the latest Ruby version. If the version number returned is less than that number (such as 2.3.7, or 1.8.7), you'll need to install a fresh copy of Ruby.
        
        ```bash
        ruby --version
        ```
        
    - Install a specific Ruby version.
        
        ```bash
        rbenv install 2.7.0
        ```
        
    - Set the default Ruby version for this machine.
        
        ```bash
        rbenv global 2.7.0
        ```
        
    - Close your Terminal window and open a new one so your changes take effect.

    - Execute this command again to ensure the default Ruby version has been set globally.
        
        ```bash
        ruby --version
        ```
        
4. SQLite3.

    - SQLite is a C-language library that implements a small, fast, self-contained, high-reliability, full-featured, SQL database engine.
    
        [SQLite Home Page](https://www.sqlite.org/)
    
    - Verify that it is correctly installed and in your load `PATH`.
    
        ```bash
        sqlite3 --version
        ```
    
    - The program should report it’s version.

5. Rails.

    - Rails is a web application development framework written in the Ruby programming language.
        
        [Getting Started with Rails — Ruby on Rails Guides](https://guides.rubyonrails.org/getting_started.html)
        
    - To install Rails, use the `gem install` command provided by RubyGems.
        
        ```bash
        gem install rails
        ```
        
    - To verify that you have everything installed correctly, you should be able to run the following in a new terminal.
        
        ```bash
        rails --version
        ```
        
    - If it says something like `Rails 7.1.0`, you are ready to continue onto engineering.

    - Otherwise, you may see this error.
        
        ```bash
        Rails is not currently installed on this system. To get the latest version, simply type:
        
            $ sudo gem install rails
        
        You can then rerun your "rails" command.
        ```
        
    - Install Rails globally.
        
        ```bash
        sudo gem install rails
        ```
        
    - If successful, execute the below command to validate rails installed globally.
        
        ```bash
        sudo rails --version
        ```
        
    - There could be another error when attempting to install Rails globally in relation to the latest version of `nokogiri`.
        
        ```bash
        The last version of nokogiri (>= 1.8.5) to support your Ruby & RubyGems was 1.15.6. Try installing it with `gem install nokogiri -v 1.15.6` and then running the current command again
        nokogiri requires Ruby version >= 3.0, < 3.4.dev. The current ruby version is 2.7.0.0.
        ```
        
    - Execute the below command with the recommended version of `nokogiri`.
        
        ```bash
        gem install nokogiri -v 1.15.6
        ```
        
    - If successful, attempt to install Rails globally again.
        
        ```bash
        sudo gem install rails
        ```
        
    - It is normal to see other errors related to gem versions being incompatible at this stage.

    - Follow the output within the Terminal to install recommended versions like above.

    - Try to install Rails globally after every new gem install until there are no errors.

    - Once successful, execute the below command to validate Rails installed globally again.
        
        ```bash
        sudo rails --version
        ```
        
    - If it says something like `Rails 7.1.3.4`, you are ready to continue onto engineering.

6. Git.

    - At the heart of GitHub is an open-source version control system (VCS) called Git.
        
        [Set up Git - GitHub Docs](https://docs.github.com/en/get-started/getting-started-with-git/set-up-git)
        
    - Git is responsible for everything GitHub-related that happens locally on your computer.
        
        [Git - Downloads](https://git-scm.com/downloads)
        
    - Install Git.

        ```bash
        brew install git
        ```

    - Set your username in Git.

        - Git uses a username to associate commits with an identity.

        - The Git username is not the same as your GitHub username.

        - Set a Git username.
            
            ```bash
            git config --global user.name "<YOUR NAME HERE>"
            ```
            
        - Confirm that you have set the Git username correctly.
            
            ```bash
            git config --global user.name
            ```
            
    - Set your commit email address in Git.

        - GitHub uses your commit email address to associate commits with your account on [GitHub.com](http://github.com/).

        - You can choose the email address that will be associated with the commits you push from the command line as well as web-based Git operations you make.

        - Any commits you made prior to changing your commit email address are still associated with your previous email address.

        - Set an email address in Git.
            
            ```bash
            git config --global user.email "<YOUR EMAIL HERE>"
            ```
            
        - Confirm that you have set the email address correctly in Git.
            
            ```bash
            git config --global user.email
            ```
            
        - Connecting to GitHub with SSH.
            - You can connect to GitHub using the Secure Shell Protocol (SSH), which provides a secure channel over an unsecured network.

            - Before you generate an SSH key, you can check to see if you have any existing SSH keys.
                
                ```bash
                ls -al ~/.ssh
                ```
                
            - Check the directory listing to see if you already have a public SSH key. By default, the filenames of supported public keys for GitHub are one of the following.

                - *id_rsa.pub*

                - *id_ecdsa.pub*

                - *id_ed25519.pub*

            - After you've checked for existing SSH keys, you can generate a new SSH key to use for authentication, then add it to the ssh-agent.

                - This creates a new SSH key, using the provided email as a label.
                    
                    ```bash
                    ssh-keygen -t ed25519 -C "<YOUR EMAIL HERE>"
                    ```
                    
                - When you're prompted to "Enter a file in which to save the key", you can press **Enter** to accept the default file location. Please note that if you created SSH keys previously, ssh-keygen may ask you to rewrite another key, in which case we recommend creating a custom-named SSH key. To do so, type the default file location and replace id_ALGORITHM with your custom key name.
                    
                    ```bash
                    Enter a file in which to save the key (/Users/YOU/.ssh/id_ALGORITHM): [Press enter]
                    ```
                    
                - At the prompt, type a secure passphrase.
                    
                    ```bash
                    > Enter passphrase (empty for no passphrase): [Type a passphrase]
                    > Enter same passphrase again: [Type passphrase again]
                    ```
                    
            - Before adding a new SSH key to the ssh-agent to manage your keys, you should have checked for existing SSH keys and generated a new SSH key. When adding your SSH key to the agent, use the default macOS `ssh-add` command, and not an application installed by `macports`, `homebrew`, or some other external source.

                - Start the ssh-agent in the background.
                    
                    ```bash
                    eval "$(ssh-agent -s)"
                    ```
                    
                - If you're using macOS Sierra 10.12.2 or later, you will need to modify your `~/.ssh/config` file to automatically load keys into the ssh-agent and store passphrases in your keychain.

                    - First, check to see if your `~/.ssh/config` file exists in the default location.
                        
                        ```bash
                        open ~/.ssh/config
                        ```
                        
                    - If the file doesn't exist, create the file.
                        
                        ```
                        touch ~/.ssh/config
                        
                        ```
                        
                    - Open your `~/.ssh/config` file, then modify the file to contain the following lines. If your SSH key file has a different name or path than the example code, modify the filename or path to match your current setup.
                        
                        ```bash
                        Host github.com
                            AddKeysToAgent yes
                            UseKeychain yes
                            IdentityFile ~/.ssh/id_ed25519
                        ```
                        
                    - Add your SSH private key to the ssh-agent and store your passphrase in the keychain. If you created your key with a different name, or if you are adding an existing key that has a different name, replace *id_ed25519* in the command with the name of your private key file.
                        
                        ```bash
                        ssh-add --apple-use-keychain ~/.ssh/id_ed25519
                        ```
                        
            - Adding a new SSH key to your GitHub account.

                - To configure your account on GitHub.com to use your new (or existing) SSH key, you'll also need to add the key to your account.

                - Copy the SSH public key to your clipboard.
                    
                    ```bash
                    pbcopy < ~/.ssh/id_ed25519.pub
                    ```
                    
                - In the "Access" section of the sidebar, click **SSH and GPG keys**.

                - Click **New SSH key** or **Add SSH key**.

                - In the "Title" field, add a descriptive label for the new key.

                - Select the type of key, either authentication or signing.

                - In the "Key" field, paste your public key.

                - Click **Add SSH key**.

                - If prompted, confirm access to your account on GitHub.

            - Testing your SSH connection.

                - After you've set up your SSH key and added it to GitHub, you can test your connection.

                - You'll need to authenticate this action using your password, which is the SSH key passphrase you created earlier.
                    
                    ```bash
                    ssh -T git@github.com
                    ```
                    
                - You may see a warning like this.
                    
                    ```
                    > The authenticity of host 'github.com (IP ADDRESS)' can't be established.> ED25519 key fingerprint is SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU.> Are you sure you want to continue connecting (yes/no)?
                    ```
                    
                - Verify that the fingerprint in the message you see matches [GitHub's public key fingerprint](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints). If it does, then type `yes`.
                    
                    ```
                    > Hi gvweston2000! You've successfully authenticated, but GitHub does not> provide shell access.
                    ```
                    
                - Verify that the resulting message contains your username. If you receive a "permission denied" message, see "[Error: Permission denied (publickey)](https://docs.github.com/en/authentication/troubleshooting-ssh/error-permission-denied-publickey).".

        - Once connected to Git, you may `git clone` this repository onto your local machine.

## Configuration.

1. `bundle install` to install gem dependencies.

2. `bin/rails server` to start Rails server. 

## Database Creation.

1. `rails db:create` to create database.

2. `rails db:migrate` to migrate migrations and create database schema.

## Database Initialization.

1. `bundle exec rake import_votes` to import vote data into the database.
