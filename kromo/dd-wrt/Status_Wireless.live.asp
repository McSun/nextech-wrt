{wl_mac::<% show_wl_mac(); %>}
{wl_ssid::<% getwirelessssid(); %>}
{wl_channel::<% get_curchannel(); %>}
{wl_radio::<% get_radio_state(); %>}
{wl_xmit::<% get_txpower(); %>}
{wl_rate::<% get_currate(); %>}
{wl_ack::<% update_acktiming(); %>}
{active_wireless::<% active_wireless(0); %>}
{active_wds::<% active_wds(0); %>}
{packet_info::<% wl_packet_get(); %>}
{uptime::<% get_uptime(); %>}
{ipinfo::<% show_wanipinfo(); %>}