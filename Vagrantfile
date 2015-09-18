Vagrant.configure("2") do |config|

    config.vm.box = "debian/jessie64"
    config.vm.box_url = "https://atlas.hashicorp.com/debian/boxes/jessie64/versions/8.2.0/providers/virtualbox.box"

    config.vm.hostname = "ezplatform"

    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.synced_folder ".", "/var/www/html", create: true, group: "www-data", owner: "vagrant"

end