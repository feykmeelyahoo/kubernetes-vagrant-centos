VAGRANTFILE_API_VERSION = "2"

load 'config.rb'

def workerIP(num)
  return "192.168.121.#{num+64}"
end

def callsh(s)
  s.inline = "sh /shared/install.sh $1 $2"
  s.args = ["dnm", "none"]
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end
  ip = "192.168.121.9"
  config.vm.box = "centos/7"
  config.vm.synced_folder ".", "/shared", type: "nfs"
  # config.vm.synced_folder ".", "/shared"
  config.vm.define "centos-master" do |master|
    master.vm.network :private_network, :ip => "#{ip}"
    master.vm.hostname = "centos-master"
    master.vm.provider "virtualbox" do |v|
      v.memory = $master_memory
      v.cpus = $master_cpus
    end
		master.vm.provision :shell, :inline => "sed 's/127.0.0.1.*master/#{ip} master/' -i /etc/hosts"
    # master.vm.provision :shell do |s|
    #   s.inline = "sh /vagrant/install.sh $1 $2 $3"
    #   s.args = ["-master", "#{ip}", "none"]
    # end
    master.vm.provision :shell do |s|
      callsh(s)
    end
    master.vm.provision :shell, :inline => "sh /shared/master.sh"
	end
  (1..$worker_count).each do |i|
    config.vm.define vm_name = "centos-minion-%d" % i do |node|
      node.vm.network :private_network, :ip => "#{workerIP(i)}"
      node.vm.hostname = vm_name
      node.vm.provider "virtualbox" do |v|
        v.memory = $worker_memory
        v.cpus = $worker_cpus
      end
      node.vm.provision :shell, :inline => "sed 's/127.0.0.1.*centos-minion-#{i}/#{workerIP(i)} centos-minion-#{i}/' -i /etc/hosts"
      node.vm.provision :shell do |s|
        callsh(s)
      end
      node.vm.provision :shell, :inline => "sed 's/KUBE_MASTER=.*/KUBE_MASTER=\"--master=http:\\/\\/centos-master:8080\"/' -i /etc/kubernetes/config"
    end
  end
end
