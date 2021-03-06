<h1>Channel list</h1>
<table id="tbl_channels" class="display">
	<thead>
		<tr>
			<th>Channel</th>
			<th>Current users</th>
			<th>Max users</th>
		</tr>
	</thead>
	<tbody>
		<tr><td colspan="3">Loading...</td></tr>
	</tbody>
</table>

{jsmin}
<script type="text/javascript"><!--
{literal}
$(document).ready(function() {
	$('#tbl_channels').dataTable({
		"bServerSide": true,
		"iDisplayLength": 25,
		"aaSorting": [[ 1, "desc" ]],
		"sAjaxSource": "rest/denora.php/channels?format=datatables",
		"aoColumns": [
			{ "mDataProp": "name", "fnRender": function(oObj) { return '<strong>'+oObj.aData['name']+'<\/strong>'; } },
			{ "mDataProp": "users" },
			{ "mDataProp": "users_max" }
		]
	});
	$("#tbl_channels tbody tr").live("click", function(event) {
		window.location = url_base + 'channel/' + encodeURIComponent(this.id) + '/profile';
	});
});
{/literal}
--></script>
{/jsmin}