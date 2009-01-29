<% do_hpagehead("route.titl"); %>
	<body>
		<div id="header">
			<div class="logo"> </div>
			<div class="navig"><a href="index.asp">Index</a> | <a href="javascript:self.close();"><% tran("sbutton.clos"); %></a></div>
		</div>
		<div id="content">
			<h2><% tran("route.h2"); %></h2>
			<dl>
				<dd>このページでは、ルーティングモードについての設定を行うことができます。ほとんどの場合、動作モードは「ゲートウェイ」のままで問題ありません。</dd>
				
				<dt><% tran("route.mod"); %></dt>

				<dd>ルーティングに関する動作モードを指定します。「ゲートウェイ」モードは、本製品がInternet側へのアクセスを提供する場合に選択します。LAN側ネットワーク内にある他のルータを使用する場合は、ゲートウェイを適切に設定する必要があります。「ゲートウェイ」モードの場合のみ、NAT機能が有効になります。</dd>
				
				<dt><% tran("route.gateway_legend"); %></dt>

				<dd>動的ルーティングを行うモードを選択した場合に、経路が制御されるインターフェースを選択します。<br /><br />
					Internet側の動的ルーティングを有効にするには、インターフェースを「WAN」に設定します。動的ルーティングを無効にするには、「無効」に設定します。

					<div class="note">
						<b>メモ</b><br />
						「ゲートウェイ」モードでは、動的ルーティング機能は動作しません
					</div>
				</dd>
				
				<dt><% tran("route.static_legend"); %></dt>
				<dd>静的経路は、予め設定する宛先ネットワークとゲートウェイルータの組み合わせを元に経路を決定します。<br /><br />
					静的経路を設定するためには次のようにします：
					<ol class="wide">
						<li>ドロップダウンリストから、登録するエントリ番号を選択します</li>
						<li>次のパラメータを設定します：
							<ul>
								<li>宛先アドレス／ネットワーク &ndash; 宛先のネットワークを示すアドレスを設定します</li>
								<li>サブネットマスク &ndash; 宛先ネットワークのサブネットマスクを設定します。</li>
								<li>ゲートウェイ &ndash; 宛先アドレスへ転送を行うことができる、本機の隣接ネットワークのルータアドレスを設定します。</li>
							</ul>
						</li>
						<li><i>LAN &amp; WLAN</i> or <i>WAN</i>を選択します。</li>
						<li>「設定」ボタンをクリックして設定を保存します。設定値を保存する場合は「設定」ボタンをクリックしてください。設定内容を破棄する場合は「キャンセル」ボタンをクリックしてください。
	経路を続けて設定する場合は、上記の手順を繰り返してください。</li>
					</ol><br />
					エントリを削除するには次のようにします：
					<ol class="wide">
						<li>ドロップダウンリストから、削除を行うエントリ番号を選択します。</li>
						<li>「削除」ボタンをクリックし、エントリを消去します。</li>
						<li>削除予定のエントリを全て削除したら、「設定」ボタンをクリックして設定を保存します。</li>
					</ol>
				</dd>
				
				<dt><% tran("sbutton.routingtab"); %></dt>

				<dd>「ルーティングテーブルの表示」をクリックすると、全ての有効な経路を表示します。各エントリには次のような情報が含まれています。
					<ul class="wide">
						<li>宛先アドレス &ndash; 静的経路として登録された宛先ネットワークのアドレスを表示します。</li>
						<li>サブネットマスク &ndash; 宛先ネットワークのサブネットマスクを表示します。</li>
						<li>ゲートウェイ &ndash; 宛先に応じたゲートウェイアドレスを表示します。</li>
						<li>インターフェース &ndash; 宛先アドレスがInternet側、LAN側、Loopback(内部ネットワーク)のいずれに存在するのか示します。</li>
					</ul><br />
					「表示を更新する」をクリックすると、画面を最新の情報で更新します。「閉じる」ボタンで前のページに戻ります。
				</dd>
			</dl>
		</div>
		<div class="also">
			<h4><% tran("share.seealso"); %></h4>
			<ul>
				<li><a href="HManagement.asp"><% tran("bmenu.adminManagement"); %></a></li>
				<li><a href="HStatusLan.asp"><% tran("bmenu.statuLAN"); %></a></li>
			</ul>
		</div>
	</body>
</html>
