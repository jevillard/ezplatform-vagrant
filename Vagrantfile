Vagrant.configure("2") do |config|

    config.vm.box = "debian/jessie64"
    config.vm.box_url = "https://atlas.hashicorp.com/debian/boxes/jessie64/versions/8.2.0/providers/virtualbox.box"

    config.vm.provider "virtualbox" do |v|
        v.customize ["modifyvm", :id, "--cpus", "2"]
        v.customize ["modifyvm", :id, "--memory", "2048"]
    end

    config.vm.hostname = "ezplatform"
    config.vm.network :forwarded_port, guest: 80, host: 8080, auto_correct: true

    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.synced_folder ".", "/var/www/html", create: true,
        owner: "vagrant",
        group: "www-data",
        mount_options: ["dmode=775,fmode=664"]

end