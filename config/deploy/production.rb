server '133.167.41.77', user: 'root', roles: %w{app db web}, port: 10022 

#デプロイするサーバーにsshログインする鍵の情報。サーバー編で作成した鍵のパス
# set :ssh_options, keys: '~/.ssh/tangent.pem'