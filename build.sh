echo "Clean out mirrors and other cache apt things"
# apt clean all
# apt python3-devel.x86_64 -y
# apt install python3-setuptools.noarch -y 
# apt install unixODBC-devel -y

echo "Pull required packages"
curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3 -
pip3 install --upgrade pip setuptools wheel
pip3 install boto3==1.20.10 --user

echo "Verify poetry installing"
