# Pysparkのローカル環境構築

## 前提条件

Mac M1

Python 3.9インストール
brew install java11
vi ~/.zshrc
echo 'export PATH="/usr/local/opt/openjdk@11/bin:$PATH"'
export CPPFLAGS="-I/usr/local/opt/openjdk@11/include"
brew install apache-spark

echo "export SPARK_HOME=/usr/local/opt/apache-spark/libexec/"
echo "export PATH=${PATH}:${SPARK_HOME}/"

mkdir /private/tmp/spark-events