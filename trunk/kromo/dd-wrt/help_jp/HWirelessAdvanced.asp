<% do_hpagehead("wl_adv.titl"); %>
	<body>
		<div id="header">
			<div class="logo"> </div>
			<div class="navig"><a href="index.asp">Index</a> | <a href="javascript:self.close();"><% tran("sbutton.clos"); %></a></div>
		</div>
		<div id="content">
			<h2>詳細(無線LAN)</h2>
			<dl>
				<dd>このページでは、無線LANで通信を行うための詳細パラメータを設定することができます。多くのパラメータは工場出荷値のまま使用することをお勧めします。</dd>
				<dt>802.11認証モード</dt>
				<dd>デフォルト値は「自動」です。802.11では、「Open」「Shared」の各認証方式があり、この製品はこれらを自動的に認識することができます。Sharedキーを使用した認証を使用する場合のみ、「共有キー」に設定してください。</dd>
				<dt>Basic Rate</dt>
				<dd>デフォルト値は"Default"です。この設定では、ほとんどの無線LANクライアントが適切な送信RateでManagement/Control通信を行うことができます。全ての使用可能な送信Rateを使用するには、「ALL」を選択します。11bデバイスとの互換性を最大にする場合は、「1-2Mbps」を選択します。</dd>
				<dt>送信Rate</dt>
				<dd>デフォルト値は「Auto」です。1〜54Mbpsまでの速度を指定した場合、アクセスポイントからの全ての通信について、定められた送信Rateを用いて行うようになります。「Auto」の場合は、定められた速度(11gの場合は1〜54Mbps, 11bの場合は1〜11Mbps)の範囲内で、適切な送信速度を選択するようになります。</dd>
				<dt>IEEE802.11g プロテクション</dt>
				<dd>デフォルト値は「無効」です。「自動」を選択した場合、11g対応クライアントが接続中に11bのみ対応の無線LANクライアントがアクセスポイントに接続されたとき、通信を保護するための手順(self CTS)を使用するようになります。</dd>
				<dt>フレームバースト</dt>
				<dd>デフォルト値は「無効」です。フレームバーストを有効にすると、無線LANの送信能力を向上させることができます。ただし、台数が多い場合(およそ4台以上)は、一般に効果が少なくなります。</dd>
				<dt>Beacon送信間隔</dt>
				<dd>デフォルト値は100です。1〜65,535までの数値を設定することができます。Beaconは無線LANクライアントとアクセスポイントが通信タイミングを同期するために使用されます。50以上の数値をお勧めします。</dd>
				<dt>DTIM 送信間隔</dt>
				<dd>デフォルト値は1です。1〜255までの数値を設定することができます。DTIMはPowerSave中の無線LANクライアントに対し、TIMを通知する間隔を示します。マルチキャスト・ブロードキャストフレームは一般にDTIMの間隔でしか送信されません。クライアントはDTIM間隔のみデータを受信するようになるので、クライアントのバッテリー寿命を延長させる個とができます。</dd>
				<dt>Fragmentation Threshold</dt>
				<dd>デフォルト値(2346)のままで使用することをお勧めします。このパラメータは送信フレーム長の最大値を示しており、256〜2346までの値を設定することができます(残りのデータは分割して送信されます)。ノイズの多い環境などで送信データのエラーが多い場合は、この値を小さくすることによってその影響を軽減することができます。</dd>
				<dt>RTS Threshold</dt>
				<dd>デフォルト値(2347)のままで使用することを強くお勧めします。ノイズや位置が原因で通信が不安定になっている場合は、このパラメータを調整することをお勧めします。送信するデータのサイズがRTS Thresholdよりも小さい場合、RTS/CTS手順を用いて通信を行う個とができるようになります。アクセスポイントはRTSフレームを送信し、それに対して受信側がCTSを返信し、アクセスポイント側が受信した後でデータの送信を開始します。</dd>
				<dt>プライバシーセパレータ</dt>
				<dd>デフォルト値は「無効」です。「有効」にすることによって無線LANクライアント同士の通信ができなくなります。</dd>
				<dt>送信アンテナ / 受信アンテナ</dt>
				<dd>「右」「左」「自動」のうちから選択できます。アンテナの送受信を固定することによって通信の最適化を行うことができるようになります。AS-A100では、「右」が上部メインアンテナを、「左」が内蔵アンテナを示します。</dd>
				<dt>PLCPヘッダ</dt>
				<dd>「Long」「Short」「自動」のいずれかを指定することができます。11gと11bデバイスを混用しており、通信が不安定である場合、「Long」を設定することで、症状が改善されることがあります。</dd>
<!--
				<dt>送信出力</dt>
				<dd>1〜251mwの範囲内で設定することができます。ほとんどの場合、70mw程度の出力が最適値になります。より多くのPower値の設定は、機器を破壊することにつながりますのでお勧めできません。</dd>
				<dt>Afterburner</dt>
				<dd>デフォルト値は「無効」です。WRT54GSのみ指定することができ、「Speedbooster」をサポートしたLinksysの「GS」の付いたクライアントとの接続時のみ有効になります。</dd>
-->
				<dt>無線LANからの設定画面のアクセス</dt>
				<dd>デフォルト値は「有効」です。無線クライアントからの設定Web画面の接続を許可できるようになります。無線LANポートからの接続を制限したい場合は「無効」を設定してください。</dd>
				<dt>無線LANタイマ</dt>
				<dd>無線LANタイマは、無線LANによる接続を提供する時間帯を設定することができます。デフォルト値は「無効」(常に無線機能が有効)です。時間帯によって無線機能を無効にしたい場合は「有効」を選択し、無効にする時間帯が赤色になるように、タイムバーをクリックします。また、全時間帯を有効もしくは無効にする場合は、「常時有効」「常時無効」をクリックします。</dd>
				<dt>Wi-Fi WMM</dt>
				<dd>WMM機能に関する設定を行います。WMMを有効に設定することによって、送信されるフレームは「AC_BK」「AC_BE」「AC_VI」「AC_VO」の各Queueごとに設定された異なる優先確率で出力されます。Queueの決定にはDSCPフィールドが使用されます。<br /><br />
					<div class="note">
						<h4>メモ</h4>
						<div>一例として、Voice, Videoのような時間条件の厳しいフレームには高い優先度を割り当て、その他のフレームに対しては低い優先度を割り当てることを推奨します。</div>
					</div>
				</dd>
				<dt>No-Acknowledgement</dt>
				<dd>通信時、送信確認(Ack)を返さないようになります。パフォーマンスにおいて有理である代わりに、ノイズの多い環境ではErrorに対して脆弱になります。</dd>
				<dt>EDCA AP Parameters (AP → クライアント)</dt>
				<dd>アクセスポイントからクライアントへの通信に使用されるパラメータを設定します。</dd>
				<dt>EDCA STA Parameters (クライアント → AP)</dt>
				<dd>クライアントからアクセスポイントへの通信に使用されるパラメータを設定します。</dd>
				<dt>AC_BK(低い)</dt>
				<dd>最も低いプライオリティです。<BR />
					FTPなど、Throughputは高いが時間制約の少ないStreamはこのQueueを使用します。</dd>
				<dt>AC_BE(通常)</dt>
				<dd>通常のプライオリティです。<BR />
					ほとんどのアプリケーションはこのQueueを使用します。</dd>
				<dt>AC_VI(優先)</dt>
				<dd>高いプライオリティを持ちます。<BR />
					ビデオストリームなど、高いプライオリティのストリームに対応します。</dd>
				<dt>AC_VO(最優先)</dt>
				<dd>最も高いプライオリティを持ちます。<BR />
					VoIPなど、クリティカルな時間条件を持つアプリケーションなどに使用します。</dd>
				<dt>CWmin</dt>
				<dd>最小コンテンション・ウィンドウサイズを指定します。コンテンション・ウィンドウはIEEE802.11で行うフレーム衝突回避機構で使用され、一般にウィンドウ内の値が小さくなるほど、そのキューが送信権を得る確率が高くなります。</dd>
				<dt>CWmax</dt>
				<dd>最大コンテンション・ウィンドウサイズを指定します。コンテンション・ウィンドウはIEEE802.11で行うフレーム衝突回避機構で使用され、一般にウィンドウ内の値が小さくなるほど、そのキューが送信権を得る確率が高くなります。</dd>
				<dt>AIFSN</dt>
				<dd>フレーム送信間隔を設定します。単位はスロット(CWmin, CWmaxで定義されるウィンドウ値と同様)です。フレーム送信間隔が小さいほど、バックオフアルゴリズムの開始時間が早まるため、結果としてキューの優先度が高くなります。</dd>
				<dt>TXOP(b) and TXOP (a/g)</dt>
				<dd>キューが送信権を得た場合に占有できる時間を示します。1単位は32msです。この時間が多いほど一度得た送信権でより多くのフレームを転送することができますが、反面キューのリアルタイム性を損なうことになります。<br>
				11bフレームの転送にはTXOP(b)、11gフレームの転送にはTXOP(g)が使用されます。</dd>
				<dd>設定値を保存する場合は「設定」ボタンをクリックしてください。設定内容を破棄する場合は「キャンセル」ボタンをクリックしてください。</dd>

			</dl>
		</div>
		<div class="also">
			<h4>See also:</h4>
			<ul>
				<li><a href="HWireless.asp">基本(無線LAN)</a></li>
				<li><a href="HWPA.asp">無線LANセキュリティ</a></li>
			</ul>
		</div>
	</body>
</html>