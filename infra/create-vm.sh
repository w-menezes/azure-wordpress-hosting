#
#
#

az vm create \
  --resource-group rg-wordpress-vm \
  --name wp-vm \
  --image Ubuntu2404 \
  --size Standard_B2ms \
  --admin-username adminuser \
  --ssh-key-name azure_pk \
  --custom-data cloud-init.txt \
  --public-ip-sku Standard