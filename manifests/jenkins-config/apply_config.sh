set -e
echo "disable Setup Wizard"
echo \$JENKINS_VERSION > /var/jenkins_home/jenkins.install.UpgradeWizard.state
echo \$JENKINS_VERSION > /var/jenkins_home/jenkins.install.InstallUtil.lastExecVersion
echo "finished initialization"