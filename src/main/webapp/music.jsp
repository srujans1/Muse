<%@ page import="com.google.appengine.api.blobstore.UploadOptions" %>

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.google.appengine.api.blobstore.BlobKey" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.Query.FilterPredicate" %>
<%@ page import="com.google.appengine.api.blobstore.UploadOptions" %>
<html>
<head>
<!-- Bootstrap core CSS -->
<link href="css/bootstrap.css" rel="stylesheet">
<link type="text/css" href="/skin/jplayer.blue.monday.css"
	rel="stylesheet" />
	<script src="http://code.jquery.com/jquery-1.11.0.min.js"
		type="text/javascript"></script>
		<script type="text/javascript" src="/js/jquery.jplayer.js"></script>
		<script type="text/javascript" src="/js/jplayer.playlist.js"></script>
		<script src="js/bootstrap.js" type="text/javascript"></script>

</head>
<body>
	<p>Hello <%=request.getSession().getAttribute("user") %></p>
	<body>
	
   <form enctype="multipart/form-data" method="post" action="<%= BlobstoreServiceFactory.getBlobstoreService().createUploadUrl("/upload", UploadOptions.Builder.withGoogleStorageBucketName("muse")) %>">
		<input type="file" name="<%=request.getSession().getAttribute("userId") %>" size="30" />
		<input type="submit" />
	</form>
	
	
	<% 
	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	Query query = new Query("Uploads");
	FilterPredicate filter = new FilterPredicate("userId", Query.FilterOperator.EQUAL, request.getSession().getAttribute("userId").toString());
	query.setFilter(filter);
	List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(100));
	BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();%>

	<script type="text/javascript">
		//<![CDATA[
		           var myPlaylist;
		$(document).ready(function(){
		
		myPlaylist = new jPlayerPlaylist({
				jPlayer: "#jquery_jplayer_1",
				cssSelectorAncestor: "#jp_container_1"
			}, [
	
	<% for (Entity greeting : greetings) { %> 
	<% out.print("{ title:\"" + greeting.getProperty("filename").toString() +"\", mp3: \"/serve?blob-key=" + greeting.getProperty("blobKey").toString() + "\"},");%> 
	<% } %>
	], {
				swfPath: "../js",
				supplied: "mp3",
				wmode: "window",
				smoothPlayBar: true,
				keyEnabled: true
			});

		});
		//]]>
	</script>
	
<div id="jquery_jplayer_1" class="jp-jplayer"></div>

		<div id="jp_container_1" class="jp-audio">
			<div class="jp-type-playlist">
				<div class="jp-gui jp-interface">
					<ul class="jp-controls">
						<li><a href="javascript:;" class="jp-previous" tabindex="1">previous</a></li>
						<li><a href="javascript:;" class="jp-play" tabindex="1">play</a></li>
						<li><a href="javascript:;" class="jp-pause" tabindex="1">pause</a></li>
						<li><a href="javascript:;" class="jp-next" tabindex="1">next</a></li>
						<li><a href="javascript:;" class="jp-stop" tabindex="1">stop</a></li>
						<li><a href="javascript:;" class="jp-mute" tabindex="1" title="mute">mute</a></li>
						<li><a href="javascript:;" class="jp-unmute" tabindex="1" title="unmute">unmute</a></li>
						<li><a href="javascript:;" class="jp-volume-max" tabindex="1" title="max volume">max volume</a></li>
					</ul>
					<div class="jp-progress">
						<div class="jp-seek-bar">
							<div class="jp-play-bar"></div>

						</div>
					</div>
					<div class="jp-volume-bar">
						<div class="jp-volume-bar-value"></div>
					</div>
					<div class="jp-current-time"></div>
					<div class="jp-duration"></div>
					<ul class="jp-toggles">
						<li><a href="javascript:;" class="jp-shuffle" tabindex="1" title="shuffle">shuffle</a></li>
						<li><a href="javascript:;" class="jp-shuffle-off" tabindex="1" title="shuffle off">shuffle off</a></li>
						<li><a href="javascript:;" class="jp-repeat" tabindex="1" title="repeat">repeat</a></li>
						<li><a href="javascript:;" class="jp-repeat-off" tabindex="1" title="repeat off">repeat off</a></li>
					</ul>
				</div>
				<div class="jp-playlist">
					<ul>
						<li></li>
					</ul>
				</div>
				<div class="jp-no-solution">
					<span>Update Required</span>
					To play the media you will need to either update your browser to a recent version or update your <a href="http://get.adobe.com/flashplayer/" target="_blank">Flash plugin</a>.
				</div>
			</div>
		</div>
		<script type="text/javascript">
		var nowPlaying;
		jQuery("#jquery_jplayer_1").bind(jQuery.jPlayer.event.play, function (event)
			    {   

			        var current         = myPlaylist.current,
			        playlist        = myPlaylist.playlist;
			        jQuery.each(playlist, function (index, obj){
			            if (index == current){
			                    nowPlaying = obj.title;
			                    $("#tweettext").val('');
			                    $("#tweettext").val('Now Playing ' + nowPlaying + ' #Muse #NowPlaying');

			            } // if condition end
			        });
			    });
		
		$('#openBtn').click(function(){
			$('#myModal').modal({show:true})
		});
		</script>

		    
<a data-toggle="modal" href="#myModal" class="btn btn-primary">Launch modal</a>

<div class="modal" id="myModal">
	<div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
          <h4 class="modal-title">Tweet your song</h4>
        </div>
        <div class="modal-body">
          <form class="form-horizontal">
			<fieldset>

			  <div class="col-md-12">                     
			    <textarea id="tweettext" class="form-control" id="textarea" name="textarea">Now Playing</textarea>
			  </div>

			</fieldset>
			</form>
        </div>
        <div class="modal-footer">
          <button id="cancel" name="cancel" class="btn btn-default" data-dismiss="modal" aria-hidden="true">Cancel</button>
           <button id="tweet" name="tweet" class="btn btn-primary">Tweet</button>
        </div>
      </div>
    </div>
</div>
</body>
</html>
