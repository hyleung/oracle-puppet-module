require 'facter'
Facter.add(:oracle_home) do
    setcode do
        Facter::Util::Resolution.exec("cat /etc/oratab | grep  -o '[/.a-z0-9]*'")
    end
end