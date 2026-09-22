# Pinned artifact runtime stack (do not upgrade without explicit approval):
#   Debian 10 (buster)
#   Google Chrome 91.0.4472.114
#   ChromeDriver 91.0.4472.101
#   Selenium 4.16.0
FROM joyzoursky/python-chromedriver@sha256:b639ffcb86ce5e0dae551a8a79b47c1e986fbc3ad6b22b34376cc52eaaae348e
USER root
RUN ls

# Base image uses EOL Debian Buster; repoint apt to archive mirrors only (keep Debian 10).
RUN printf 'deb http://archive.debian.org/debian buster main\n\
deb http://archive.debian.org/debian-security buster/updates main\n' > /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FD533C07C264648F

RUN apt-get update
RUN apt install -y nodejs
RUN apt install -y npm
RUN apt install -y tree
RUN apt-get install -y tmux
RUN apt-get install -y graphviz
RUN apt-get install -y graphviz-dev
RUN apt install -y xvfb

RUN pip3 install numpy==1.25.2
RUN pip3 install pandas
RUN pip install scikit-learn==1.3.0
RUN pip3 install adblockparser
RUN pip3 install openpyxl
RUN pip3 install pyvirtualdisplay
RUN pip3 install selenium==4.16.0
RUN pip3 install seaborn
RUN pip3 install tldextract
RUN pip3 install webdriver-manager
RUN pip3 install matplotlib
RUN pip3 install xlrd
RUN pip3 install beautifulsoup4
RUN pip3 install httpx
RUN pip3 install joblib
RUN pip3 install graphviz
RUN pip3 install networkx
RUN pip3 install pygraphviz
RUN pip3 install gdown

WORKDIR /Crawler
COPY . /Crawler

# Fail the build if the pinned browser stack drifts.
RUN google-chrome --version | grep -q '91.0.4472' && \
    chromedriver --version | grep -q '91.0.4472' && \
    grep -q 'VERSION_ID="10"' /etc/os-release && \
    pip3 show selenium | grep -q 'Version: 4.16.0'

CMD ["/bin/bash"]