[![Build Status](https://img.shields.io/travis/shinesolutions/ruby_aem.svg)](http://travis-ci.org/shinesolutions/ruby_aem)
[![Published Version](https://badge.fury.io/rb/ruby_aem.svg)](https://rubygems.org/gems/ruby_aem)

ruby_aem
--------

ruby_aem is a Ruby client for [Adobe Experience Manager (AEM)](http://www.adobe.com/au/marketing-cloud/enterprise-content-management.html) API.
It is written on top of [swagger_aem](https://github.com/shinesolutions/swagger-aem/blob/master/ruby/README.md) and provides resource-oriented API and convenient response handling.

[Versions History](docs/versions.md)

Install
-------

    gem install ruby_aem

Usage
-----

Initialise client:

    require 'ruby_aem'

    aem = RubyAem::Aem.new({
      username: 'admin',
      password: 'admin',
      protocol: 'http',
      host: 'localhost',
      port: 4502,
      :timeout => 300,
      debug: false
    })

Aem:

    # wait until AEM login page is ready
    aem = aem.aem
    result = aem.get_login_page_wait_until_ready({
      _retries: {
        max_tries: 60,
        base_sleep_seconds: 2,
        max_sleep_seconds: 2
      }})

    # wait until AEM Health Check has OK status
    # this requires aem-healthcheck package to be installed
    # https://github.com/shinesolutions/aem-healthcheck
    aem = aem.aem
    result = aem.get_aem_health_check_wait_until_ok({
      tags: 'shallow',
      combine_tags_or: false,
      _retries: {
        max_tries: 60,
        base_sleep_seconds: 2,
        max_sleep_seconds: 2
      }})

    # get an array of all agent names within AEM author or publish instance
    aem = aem.aem
    result = aem.get_agents('author')

Bundle:

    # stop bundle
    bundle = aem.bundle('com.adobe.cq.social.cq-social-forum')
    result = bundle.stop

    # start bundle
    bundle = aem.bundle('com.adobe.cq.social.cq-social-forum')
    result = bundle.start

Configuration property:

    config_property = aem.config_property('someproperty', 'Boolean', true)

    # set config property on /apps/system/config.author/somenode
    result = config_property.create('author', 'somenode')

Flush agent:

    flush_agent = aem.flush_agent('author', 'some-flush-agent')

    # create or update flush agent
    opts = { log_level: 'info', retry_delay: 60_000 }
    result = flush_agent.create_update('Some Flush Agent Title', 'Some flush agent description', 'http://somehost:8080', opts)

    # check flush agent's existence
    result = flush_agent.exists

    # delete flush agent
    result = flush_agent.delete

Group:

    # create group
    group = aem.group('/home/groups/s/', 'somegroup')

    # check group's existence
    result = group.exists

    # set group permission
    result = group.set_permission('/etc/replication', 'read:true,modify:true')

    # add another group as a member
    member_group = aem.group('/home/groups/s/', 'somemembergroup')
    result = member_group.create
    result = group.add_member('somemembergroup')

    # delete group
    result = group.delete

Node:

    node = aem.node('/apps/system/', 'somefolder')

    # create node
    result = node.create('sling:Folder')

    # check node's existence
    result = node.exists

    # delete node
    result = node.delete

Package:

    package = aem.package('somepackagegroup', 'somepackage', '1.2.3')

    # upload package located at /tmp/somepackage-1.2.3.zip
    opts = { force: true }
    result = package.upload('/tmp', opts)

    # check whether package is uploaded
    result = package.is_uploaded

    # install package
    opts = { recursive: true }
    result = package.install(opts)

    # uninstall package
    result = package.uninstall(opts)

    # check whether package is installed
    result = package.is_installed

    # replicate package
    result = package.replicate

    # download package to /tmp directory
    result = package.download('/tmp')

    # create package
    result = package.create

    # build package
    result = package.build

    # build package and wait until package is built (package exists and size is not empty)
    result = package.build_wait_until_ready

    # check whether package is built
    result = package.is_built

    # update package filter
    result = package.update('[{"root":"/apps/geometrixx","rules":[]},{"root":"/apps/geometrixx-common","rules":[]}]')

    # get package filter
    result = package.get_filter

    # activate filter
    results = package.activate_filter(true, false)

    # list all packages
    result = package.list_all

    # check whether package is empty
    result = package.is_empty

    # get all versions of the package
    result = package.get_versions

Path:

    # check path's existence
    path = aem.path('/etc/designs/cloudservices')
    result = path.activate(true, false)

    # tree activate the path
    path = aem.path('/etc/designs')
    result = path.activate(true, false)

Replication agent:

    replication_agent = aem.replication_agent('author', 'some-replication-agent')

    # create or update replication agent
    opts = {
      transport_user: 'admin',
      transport_password: 'admin',
      log_level: 'info',
      retry_delay: 60_000
    }
    result = replication_agent.create_update('Some Replication Agent Title', 'Some replication agent description', 'http://somehost:8080', opts)

    # check replication agent's existence
    result = replication_agent.exists

    # delete replication agent
    result = replication_agent.delete

Outbox replication agent:

    outbox_replication_agent = aem.outbox_replication_agent('publish', 'some-outbox-replication-agent')

    # create or update outbox replication agent
    opts = {
      user_id: 'admin',
      log_level: 'info'
    }
    result = outbox_replication_agent.create_update('Some Outbox Replication Agent Title', 'Some outbox replication agent description', 'http://somehost:8080', opts)

    # check outbox replication agent's existence
    result = outbox_replication_agent.exists

    # delete outbox replication agent
    result = outbox_replication_agent.delete

Reverse replication agent:

    reverse_replication_agent = aem.reverse_replication_agent('author', 'some-reverse-replication-agent')

    # create or update reverse replication agent
    opts = {
      transport_user: 'admin',
      transport_password: 'admin',
      log_level: 'info',
      retry_delay: 60_000
    }
    result = reverse_replication_agent.create_update('Some Reverse Replication Agent Title', 'Some reverse replication agent description', 'http://somehost:8080', opts)

    # check reverse replication agent's existence
    result = reverse_replication_agent.exists

    # delete reverse replication agent
    result = reverse_replication_agent.delete

Repository:

    repository = aem.repository

    # block repository writes
    result = repository.block_writes

    # unblock repository writes
    result = repository.unblock_writes

User:

    user = aem.user('/home/users/s/', 'someuser')

    # create user
    result = user.create('somepassword')

    # check user's existence
    result = user.exists

    # set user permission
    result = user.set_permission('/etc/replication', 'read:true,modify:true')

    # change user password
    result = user.change_password('somepassword', 'somenewpassword')

    # add user to group
    result = user.add_to_group('/home/groups/s/', 'somegroup')

    # delete user
    result = user.delete

Result
------

Each of the above method calls returns a [RubyAem::Result](https://shinesolutions.github.io/ruby_aem/api/master/RubyAem/Result.html), which contains message, [RubyAem::Response](https://shinesolutions.github.io/ruby_aem/api/master/RubyAem/Response.html), and data payload. For example:

    bundle = aem.bundle('com.adobe.cq.social.cq-social-forum')
    result = bundle.stop
    puts result.message
    puts result.response.status_code
    puts result.response.body
    puts result.response.headers
    puts result.data

Error handling
--------------

Any API error will be thrown as [RubyAem::Error](https://shinesolutions.github.io/ruby_aem/api/master/RubyAem/Error.html) .

    begin
      bundle = aem.bundle('com.adobe.cq.social.cq-social-forum')
      result = bundle.stop
    rescue RubyAem::Error => err
      puts err.message
      puts err.result.response.status_code
      puts err.result.response.body
      puts err.result.response.headers
      puts err.result.data
    end

Testing
-------

Integration tests require an AEM instance running on port 4502 with [Shine Solutions AEM Health Check](https://github.com/shinesolutions/aem-healthcheck) package installed.

Reports
-------

* [API - master](https://shinesolutions.github.io/ruby_aem/api/master/index.html)
* [Coverage report](https://shinesolutions.github.io/ruby_aem/coverage/index.html)
