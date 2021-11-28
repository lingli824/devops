#!/bin/bash
sudo apt update
sudo apt install openjdk-8-jdk wget rsync -y   
sudo mkdir -p /opt/nexus/   
sudo mkdir -p /tmp/nexus/                           
cd /tmp/nexus
NEXUSURL="https://sonatype-download.global.ssl.fastly.net/repository/downloads-prod-group/3/nexus-3.29.2-02-unix.tar.gz"
wget $NEXUSURL -O nexus.tar.gz
EXTOUT=`tar xzvf nexus.tar.gz`
NEXUSDIR=`echo $EXTOUT | cut -d '/' -f1`
sudo rm -rf /tmp/nexus/nexus.tar.gz
sudo rsync -avzh /tmp/nexus/ /opt/nexus/
sudo useradd -M -d /opt/nexus -s /bin/bash -r nexus
echo "nexus   ALL=(ALL)       NOPASSWD: ALL" | sudo tee /etc/sudoers.d/nexus
sudo chown -R nexus.nexus /opt/nexus 
cat <<EOT | sudo tee -a /etc/systemd/system/nexus.service
[Unit]                                                                          
Description=nexus service                                                       
After=network.target                                                            
                                                                  
[Service]                                                                       
Type=forking                                                                    
LimitNOFILE=65536                                                               
ExecStart=/opt/nexus/$NEXUSDIR/bin/nexus start                                  
ExecStop=/opt/nexus/$NEXUSDIR/bin/nexus stop                                    
User=nexus                                                                      
Restart=on-abort                                                                
                                                                  
[Install]                                                                       
WantedBy=multi-user.target                                                      

EOT

echo 'run_as_user="nexus"' | sudo tee /opt/nexus/$NEXUSDIR/bin/nexus.rc
sudo systemctl daemon-reload
sudo systemctl start nexus
sudo systemctl enable nexus
