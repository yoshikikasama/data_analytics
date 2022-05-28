# データ分析基盤

■データ分析基盤の変遷
- データ: パターンと関係を捉えるための情報源
- 構造データ: RDBといったスキーマが決まっているデータ
- 半構造データ: CSVやJSONのように配置場所は決まっているもののデータ型が決まっていないもの
- 非構造データ: ExcelやPDFなどのスキーマが決まっていないデータ

■データ分析基盤とは
- 社内で(もしくは社外含め)利用される単一のデータ統合プラットフォーム
- 社内外のありとあらゆるデータが混ざり合うことで、様々な知見をデータから得ようという動きがあり、  
%nbsp;データ分析基盤の主な役割は、それらのデータから「パターン」や「関係」を知るためのサポートを行うこと。

■データ分析の変遷
- ノード: サーバーを示す単位。
- クラスター: 複数のノードを束ねて一つのノードのように操作するマルチノード。
- オンプレミス: サーバーやネットワーク機器を自社で保有し運用すること。

■主要なビッグデータシステム用サービス
- データを保存する
    - AWS: S3, Redshift
    - GCP: Cloud Storage, BigQuery
    - Azure: Blob Storage, Synapse Analytics
- データを処理する
    - AWS: EMR, Redshift
    - GCP: BigQuery
    - Azure: HDInsight, Synapse Analytics
- メタデータと連携する
    - AWS: Glue Data Catalog
    - GCP: Data Catalog
    - Azure: Data Catalog
- データを利用する(SQL)
    - AWS: Athena, Redshift
    - GCP: BigQuery
    - Azure: Data Lake Analytics, SynapseAnalytics
- AWSを用いたデータ利用までの流れ
    - スケーラブルなクラウドストレージに配置(S3など)
    - 配置されたデータを処理して表形式に対応できるように構造化データに変更する(EMR)
    - 構造化データに対してスキーマを付与する(Glue Data Catalog)
    - SQLでデータを参照して分析する(Athena)

■データ分析基盤が持つ役割

|  種別  |  ファイルの種類  | 形態  | 主な技術例 | 主な役割 |
| ---- | ---- | ---- | ---- | ---- |
|  datalake  |  なんでもOK(JSON/CSV/EXCEL/PDF)  |  構造化/非構造化  |  Python/Java  |  ローデータ保管、一時データ保存、データの受付口  |
|  DWH  |  Parquet/Avro  |  構造化  |  Python/SQL  |  構造データ保管や機密データ保存、管理番号(meta data)が振られた状態。  |
|  data mart  |  Parquet/Avro  |  構造化  |  SQL  |  構造データ保管(DWHより整備されたデータ) 。データが加工され、市場(mart)に売りに出された状態。データが整理されていて、「ダッシュボード」として表示するためのデータがすぐに取り出し可能である。 |

- データレイク、DWH、データマートの違いは