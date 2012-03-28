<h1>Live Network Status</h1>

<table class="details" style="width:100%;">
	<tr>
		<th colspan="2"><h3>Users</h3></th>
		<th colspan="2"><h3>Channels</h3></th>
		<th colspan="2"><h3>Operators</h3></th>
		<th colspan="2"><h3>Servers</h3></th>
	</tr>
	<tr>
		<th>Current:</th><td><span id="net_users" class="val"></span></td>
		<th>Current:</th><td><span id="net_chans" class="val"></span></td>
		<th>Current:</th><td><span id="net_opers" class="val"></span></td>
		<th>Current:</th><td><span id="net_servers" class="val"></span></td>
	</tr>
	<tr>
		<th>Peak:</th><td><span id="net_users_max" class="val"></span> on <span id="net_users_max_time"></span></td>
		<th>Peak:</th><td><span id="net_chans_max" class="val"></span> on <span id="net_chans_max_time"></span></td>
		<th>Peak:</th><td><span id="net_opers_max" class="val"></span> on <span id="net_opers_max_time"></span></td>
		<th>Peak:</th><td><span id="net_servers_max" class="val"></span> on <span id="net_servers_max_time"></span></td>
	</tr>
	<tr>
		<th>Today:</th><td><span id="net_users_today" class="val"></span> on <span id="net_users_today_time"></span></td>
		<td colspan="2" rowspan="3">&nbsp;</td>
	</tr>
</table>

<table>
	<tr>
		<td><div id="chart_users" style="height: 175px; width: 560px;"></div></td>
		<td><div id="chart_status" style="height: 175px; width: 280px;"></div></td>
	</tr>
</table>

<table class="details" style="width:100%;">
	<tr>
		<th style="width:33%;"><h3>Current 10 Biggest Chans</h3></th>
		<th style="width:33%;"><h3>Top 10 Channels Today</h3></th>
		<th style="width:33%;"><h3>Top 10 Users Today</h3></th>
	</tr>
	<tr>
		<td valign="top">
			<table id="tbl_biggestchans" class="display">
				<thead>
					<tr>
						<th>Channel</th>
						<th>Users</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td colspan="2">Loading...</td>
					</tr>
				</tbody>
			</table>
		</td>
		<td valign="top">
			<table id="tbl_top10chans" class="display">
				<thead>
					<tr>
						<th>Channel</th>
						<th>Lines</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td colspan="2">Loading...</td>
					</tr>
				</tbody>
			</table>
		</td>
		<td valign="top">
			<table id="tbl_top10users" class="display">
				<thead>
					<tr>
						<th>User</th>
						<th>Lines</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td colspan="2">Loading...</td>
					</tr>
				</tbody>
			</table>
		</td>
	</tr>
</table>

<script type="text/javascript">
<!--
$(function() {
	//TODO: make refresh configurable and do not run if the tab is not active
	var status_refresh = 15; // seconds
	var tbl_refresh = 15; // seconds
	var count = 0;

	var chart_users = new Highcharts.Chart({
		colors: ['#89A54E'],
		chart: { renderTo: 'chart_users', events: { load: startCron() } },
		yAxis: { title: { text: 'Users' } },
		series: [{ name: 'Users', data: initData() }]
	});
	var chart_status = new Highcharts.Chart({
		chart: { renderTo: 'chart_status', type: 'column', events: { load: startCron() } },
		xAxis: { type: 'linear', categories: [ 'Users', 'Channels', 'Operators', 'Servers' ], labels: { rotation: -45, align: 'right' } },
		yAxis: { min: 0, title: { text: '' } },
		tooltip: { formatter: function() { return '<b>'+ this.x +'</b>: '+ Highcharts.numberFormat(this.y, 0); } },
		series: [{ name: 'Status', data: [0, 0, 0] }]
	});

	function startCron() {
		count++;
		if (count >= 2) {
			updateStatus();
			updateMax();
			setInterval(updateStatus, status_refresh * 1000);
			setInterval(updateTables, tbl_refresh * 1000);
		}
	}
	function updateStatus() {
		$.getJSON('rest/denora.php/network/status', function(result) {
			var x = (new Date()).getTime();
			chart_users.series[0].addPoint([x, result.users.val], true, true);
			chart_status.series[0].setData([result.users.val, result.chans.val, result.opers.val, result.servers.val]);
			$("#net_users").html(result.users.val);
			if ($("#net_users").html() > $("#net_users_max")) {
				$("#net_users_max").html(result.users.val);
				$("#net_users_max_time").html(result.users.time);
			}
			$("#net_users_today").html(result.daily_users.val);
			$("#net_users_today_time").html(result.daily_users.time);
			$("#net_chans").html(result.chans.val);
			if ($("#net_chans").html() > $("#net_chans_max")) {
				$("#net_chans_max").html(result.chans.val);
				$("#net_chans_max_time").html(result.chans.time);
			}
			$("#net_servers").html(result.servers.val);
			if ($("#net_servers").html() > $("#net_servers_max")) {
				$("#net_servers_max").html(result.servers.val);
				$("#net_servers_max_time").html(result.servers.time);
			}
			$("#net_opers").html(result.opers.val);
			if ($("#net_opers").html() > $("#net_opers_max")) {
				$("#net_opers_max").html(result.opers.val);
				$("#net_opers_max_time").html(result.opers.time);
			}
		});
	}
	function updateMax() {
		$.getJSON('rest/denora.php/network/max', function(result) {
			$("#net_users_max").html(result.users.val);
			$("#net_chans_max").html(result.channels.val);
			$("#net_servers_max").html(result.servers.val);
			$("#net_opers_max").html(result.opers.val);
			$("#net_users_max_time").html(result.users.time);
			$("#net_chans_max_time").html(result.channels.time);
			$("#net_servers_max_time").html(result.servers.time);
			$("#net_opers_max_time").html(result.opers.time);
		});
	}
	function updateTables() {
		oTable1.fnReloadAjax();
		oTable2.fnReloadAjax();
		oTable3.fnReloadAjax();
	}
	function initData() {
		var data = [], time = (new Date()).getTime();
		for (i = -19; i <= 0; i++) {
			data.push({ x: time + i * status_refresh * 1000, y: null });
		}
		return data;
	}
	$.extend($.fn.dataTable.defaults, {
        "bProcessing": false,
		"bFilter": false,
		"bInfo": false,
		"bLengthChange": false,
		"bPaginate": false,
		"bSort": false,
		"bEscapeRegex": false
    });
	oTable1 = $("#tbl_biggestchans").dataTable({
		"sAjaxSource": "rest/denora.php/channels/biggest/10?format=datatables",
		"aoColumns": [
			{ "mDataProp": "channel" },
			{ "mDataProp": "currentusers" }
		]
	});
	$("#tbl_biggestchans tbody tr").live("click", function(event) {
		var chan = $(event.target.parentNode)[0].cells[0].innerHTML;
		window.location = url_base + '/channel/' + escape(chan) + '/profile';
	});
	oTable2 = $("#tbl_top10chans").dataTable({
		"sAjaxSource": "rest/denora.php/channels/top/10?format=datatables",
		"aoColumns": [
			{ "mDataProp": "chan" },
			{ "mDataProp": "line" }
		]
	});
	$("#tbl_top10chans tbody tr").live("click", function(event) {
		var chan = $(event.target.parentNode)[0].cells[0].innerHTML;
		window.location = url_base + '/channel/' + escape(chan) + '/profile#ui-tabs-4';
	});
	oTable3 = $("#tbl_top10users").dataTable({
		"sAjaxSource": "rest/denora.php/users/top/10?format=datatables",
		"aoColumns": [
			{ "mDataProp": "uname" },
			{ "mDataProp": "line" }
		]
	});
	$("#tbl_top10users tbody tr").live("click", function(event) {
		var user = $(event.target.parentNode)[0].cells[0].innerHTML;
		window.location = url_base + '/user/' + escape(user) + '/profile';
	});
});
-->
</script>