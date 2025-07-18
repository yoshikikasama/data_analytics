# memo

- ユーザーごとのテナント モデル:
  - 必要に応じてスケールアップ、スケールダウン、スケールアウトできる専用のデータベースとコンピューティング リソースが各顧客に提供されます。
- デュアル実行:
  - DuckDB の超軽量アーキテクチャにより、各 MotherDuck クライアントは SQL クエリも処理できます。これにより、 MotherDuck ユーザーに提供される列エクスプローラーやインスタント SQL のように、ほぼ瞬時にデータをフィルタリングおよびドリルダウンする機能を顧客に提供できます。
- 分析向けに設計されたデータベースとクエリエンジンへの移行は最初のステップです。しかし、従来の OLAP エンジンの多くは、社内分析/BI ユースケースのみを想定して設計されています。これらのエンジンは、すべての顧客データに対して単一のインスタンス（またはクラスター）としてプロビジョニングされるため、ピーク負荷時にリソースが過剰にプロビジョニングされ、レイテンシやセキュリティ上の懸念に加えて、深刻な「ノイジーネイバー」問題を引き起こします。
- MotherDuck は、これらのユースケースに対応するため、お客様（またはお客様のユーザー）ごとに Duckling（DuckDB インスタンス）をプロビジョニングします。この「ハイパーテナンシー」モデルは、顧客データを分離し、個々のユーザーに DuckDB を活用した優れたエクスペリエンスを提供します。重要なのは、アプリケーションのスケールに合わせて、従来のデータベースアーキテクチャよりもはるかにコスト効率の高い方法で、ユーザー向けにキャパシティを簡単に追加できるということです。
- お客様（そして場合によってはそのユーザー）それぞれに、MotherDuck Duckling（DuckDB インスタンス）が存在します。つまり、1 つのアカウントで数百、数千の Duckling を同時に実行することも、全く実行しないことも可能なのです。このサーバーレスモデルこそが、他のエンジンに対する MotherDuck の優位性の核心です。もちろん、Duckling の数が増えるだけではありません。お客様がより多くのコンピューティング能力やメモリを必要とした場合、どうすれば良いでしょうか？MotherDuck には、より大規模なワークロードにも対応できるスケールアップ可能な複数のインスタンスサイズが用意されています。
- MotherDuck Ducklings とお客様のマシンの両方で同じ DuckDB SQL エンジンが実行されるため、データ処理の一部をお客様のラップトップにオフロードし、SQL クエリを使用してデータの探索、フィルタリング、並べ替えなどを瞬時に実行できます。DuckDB は Web アセンブリ（Wasm）と呼ばれる技術を使用して Web ブラウザ内で実行されるため、お客様のコンピュータに何もインストールする必要はありません。
- MotherDuck は、 DuckDB を基盤とするクラウドネイティブなデータウェアハウスです。DuckDB の高速分析エンジンに、クラウドストレージ、共有、コラボレーションといったエンタープライズ向け機能を追加します。このプラットフォームは、サーバーレスアーキテクチャ、共有モデル、そして WASM 機能を通じてこれらのニーズに対応します。AI 支援 SQL を利用するデータアナリスト、dbt などの使い慣れたツールを利用するデータエンジニア、そしてハイブリッドなローカルクラウド処理を利用するデータサイエンティストにとって、メリットをもたらします。
