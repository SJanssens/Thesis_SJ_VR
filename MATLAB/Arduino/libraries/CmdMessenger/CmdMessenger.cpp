  


<!DOCTYPE html>
<html>
  <head prefix="og: http://ogp.me/ns# fb: http://ogp.me/ns/fb# githubog: http://ogp.me/ns/fb/githubog#">
    <meta charset='utf-8'>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>CmdMessenger/CmdMessenger.cpp at master · dreamcat4/CmdMessenger</title>
    <link rel="search" type="application/opensearchdescription+xml" href="/opensearch.xml" title="GitHub" />
    <link rel="fluid-icon" href="https://github.com/fluidicon.png" title="GitHub" />
    <link rel="apple-touch-icon" sizes="57x57" href="/apple-touch-icon-114.png" />
    <link rel="apple-touch-icon" sizes="114x114" href="/apple-touch-icon-114.png" />
    <link rel="apple-touch-icon" sizes="72x72" href="/apple-touch-icon-144.png" />
    <link rel="apple-touch-icon" sizes="144x144" href="/apple-touch-icon-144.png" />
    <link rel="logo" type="image/svg" href="http://github-media-downloads.s3.amazonaws.com/github-logo.svg" />
    <meta name="msapplication-TileImage" content="/windows-tile.png">
    <meta name="msapplication-TileColor" content="#ffffff">

    
    
    <link rel="icon" type="image/x-icon" href="/favicon.ico" />

    <meta content="authenticity_token" name="csrf-param" />
<meta content="Uvuxp4+uE6vQiBnoEVIMx+Glpn+IaDTSyAlT7qF3hvY=" name="csrf-token" />

    <link href="https://a248.e.akamai.net/assets.github.com/assets/github-8c237cc402e3d4bc024750691ccce4fd5eddee2e.css" media="all" rel="stylesheet" type="text/css" />
    <link href="https://a248.e.akamai.net/assets.github.com/assets/github2-9b6eed4e9a41cc2dd85690cc19abdc063bd87d9a.css" media="all" rel="stylesheet" type="text/css" />
    


      <script src="https://a248.e.akamai.net/assets.github.com/assets/frameworks-d76b58e749b52bc47a4c46620bf2c320fabe5248.js" type="text/javascript"></script>
      <script src="https://a248.e.akamai.net/assets.github.com/assets/github-80a3b7f6948ed4122df090b89e975d21a9c88297.js" type="text/javascript"></script>
      
      <meta http-equiv="x-pjax-version" content="581859cfff990c09f7c9d19575e3e6f4">

        <link data-pjax-transient rel='permalink' href='/dreamcat4/CmdMessenger/blob/2aa7caa3beadb2257ec811b04b9e4983f78ee80d/CmdMessenger.cpp'>
    <meta property="og:title" content="CmdMessenger"/>
    <meta property="og:type" content="githubog:gitrepository"/>
    <meta property="og:url" content="https://github.com/dreamcat4/CmdMessenger"/>
    <meta property="og:image" content="https://secure.gravatar.com/avatar/373aea769d4accb42aeb1cffaa935774?s=420&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png"/>
    <meta property="og:site_name" content="GitHub"/>
    <meta property="og:description" content="Fork of Neil Dudman&#39;s CmdMessenger. Serial messaging system for Arduino platform"/>
    <meta property="twitter:card" content="summary"/>
    <meta property="twitter:site" content="@GitHub">
    <meta property="twitter:title" content="dreamcat4/CmdMessenger"/>

    <meta name="description" content="Fork of Neil Dudman&#39;s CmdMessenger. Serial messaging system for Arduino platform" />

  <link href="https://github.com/dreamcat4/CmdMessenger/commits/master.atom" rel="alternate" title="Recent Commits to CmdMessenger:master" type="application/atom+xml" />

  </head>


  <body class="logged_in page-blob windows vis-public env-production  ">
    <div id="wrapper">

      

      

      

      


        <div class="header header-logged-in true">
          <div class="container clearfix">

            <a class="header-logo-blacktocat" href="https://github.com/">
  <span class="mega-icon mega-icon-blacktocat"></span>
</a>

            <div class="divider-vertical"></div>

              <a href="/notifications" class="notification-indicator tooltipped downwards" title="You have no unread notifications">
    <span class="mail-status all-read"></span>
  </a>
  <div class="divider-vertical"></div>


              <div class="command-bar js-command-bar  ">
      <form accept-charset="UTF-8" action="/search" class="command-bar-form" id="top_search_form" method="get">
  <a href="/search/advanced" class="advanced-search-icon tooltipped downwards command-bar-search" id="advanced_search" title="Advanced search"><span class="mini-icon mini-icon-advanced-search "></span></a>

  <input type="text" name="q" id="js-command-bar-field" placeholder="Search or type a command" tabindex="1" data-username="hvanhamm" autocapitalize="off">

  <span class="mini-icon help tooltipped downwards" title="Show command bar help">
    <span class="mini-icon mini-icon-help"></span>
  </span>

  <input type="hidden" name="ref" value="commandbar">

  <div class="divider-vertical"></div>
</form>
  <ul class="top-nav">
      <li class="explore"><a href="https://github.com/explore">Explore</a></li>
      <li><a href="https://gist.github.com">Gist</a></li>
      <li><a href="/blog">Blog</a></li>
    <li><a href="http://help.github.com">Help</a></li>
  </ul>
</div>


            

  
    <ul id="user-links">
      <li>
        <a href="https://github.com/hvanhamm" class="name">
          <img height="20" src="https://secure.gravatar.com/avatar/aaed9a6d784163d10d4a825c007a10c5?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="20" /> hvanhamm
        </a>
      </li>
      <li>
        <a href="/new" id="new_repo" class="tooltipped downwards" title="Create a new repo">
          <span class="mini-icon mini-icon-create"></span>
        </a>
      </li>
      <li>
        <a href="/settings/profile" id="account_settings"
          class="tooltipped downwards"
          title="Account settings (You have no verified emails)">
          <span class="mini-icon mini-icon-account-settings"></span>
            <span class="setting_warning">!</span>
        </a>
      </li>
      <li>
        <a href="/logout" data-method="post" id="logout" class="tooltipped downwards" title="Sign out">
          <span class="mini-icon mini-icon-logout"></span>
        </a>
      </li>
    </ul>



            
          </div>
        </div>


      <div class="global-notice warn"><div class="global-notice-inner"><h2>You don't have any verified emails.  We recommend <a href="https://github.com/settings/emails">verifying</a> at least one email.</h2><p>Email verification will help our support team help you in case you have any email issues or lose your password.</p></div></div>

      


            <div class="site hfeed" itemscope itemtype="http://schema.org/WebPage">
      <div class="hentry">
        
        <div class="pagehead repohead instapaper_ignore readability-menu ">
          <div class="container">
            <div class="title-actions-bar">
              


<ul class="pagehead-actions">


    <li class="subscription">
      <form accept-charset="UTF-8" action="/notifications/subscribe" data-autosubmit="true" data-remote="true" method="post"><div style="margin:0;padding:0;display:inline"><input name="authenticity_token" type="hidden" value="Uvuxp4+uE6vQiBnoEVIMx+Glpn+IaDTSyAlT7qF3hvY=" /></div>  <input id="repository_id" name="repository_id" type="hidden" value="1383721" />

    <div class="select-menu js-menu-container js-select-menu">
      <span class="minibutton select-menu-button js-menu-target">
        <span class="js-select-button">
          <span class="mini-icon mini-icon-watching"></span>
          Watch
        </span>
      </span>

      <div class="select-menu-modal-holder js-menu-content">
        <div class="select-menu-modal">
          <div class="select-menu-header">
            <span class="select-menu-title">Notification status</span>
            <span class="mini-icon mini-icon-remove-close js-menu-close"></span>
          </div> <!-- /.select-menu-header -->

          <div class="select-menu-list js-navigation-container">

            <div class="select-menu-item js-navigation-item js-navigation-target selected">
              <span class="select-menu-item-icon mini-icon mini-icon-confirm"></span>
              <div class="select-menu-item-text">
                <input checked="checked" id="do_included" name="do" type="radio" value="included" />
                <h4>Not watching</h4>
                <span class="description">You only receive notifications for discussions in which you participate or are @mentioned.</span>
                <span class="js-select-button-text hidden-select-button-text">
                  <span class="mini-icon mini-icon-watching"></span>
                  Watch
                </span>
              </div>
            </div> <!-- /.select-menu-item -->

            <div class="select-menu-item js-navigation-item js-navigation-target ">
              <span class="select-menu-item-icon mini-icon mini-icon-confirm"></span>
              <div class="select-menu-item-text">
                <input id="do_subscribed" name="do" type="radio" value="subscribed" />
                <h4>Watching</h4>
                <span class="description">You receive notifications for all discussions in this repository.</span>
                <span class="js-select-button-text hidden-select-button-text">
                  <span class="mini-icon mini-icon-unwatch"></span>
                  Unwatch
                </span>
              </div>
            </div> <!-- /.select-menu-item -->

            <div class="select-menu-item js-navigation-item js-navigation-target ">
              <span class="select-menu-item-icon mini-icon mini-icon-confirm"></span>
              <div class="select-menu-item-text">
                <input id="do_ignore" name="do" type="radio" value="ignore" />
                <h4>Ignoring</h4>
                <span class="description">You do not receive any notifications for discussions in this repository.</span>
                <span class="js-select-button-text hidden-select-button-text">
                  <span class="mini-icon mini-icon-mute"></span>
                  Stop ignoring
                </span>
              </div>
            </div> <!-- /.select-menu-item -->

          </div> <!-- /.select-menu-list -->

        </div> <!-- /.select-menu-modal -->
      </div> <!-- /.select-menu-modal-holder -->
    </div> <!-- /.select-menu -->

</form>
    </li>

    <li class="js-toggler-container js-social-container starring-container ">
      <a href="/dreamcat4/CmdMessenger/unstar" class="minibutton js-toggler-target star-button starred upwards" title="Unstar this repo" data-remote="true" data-method="post" rel="nofollow">
        <span class="mini-icon mini-icon-remove-star"></span>
        <span class="text">Unstar</span>
      </a>
      <a href="/dreamcat4/CmdMessenger/star" class="minibutton js-toggler-target star-button unstarred upwards" title="Star this repo" data-remote="true" data-method="post" rel="nofollow">
        <span class="mini-icon mini-icon-star"></span>
        <span class="text">Star</span>
      </a>
      <a class="social-count js-social-count" href="/dreamcat4/CmdMessenger/stargazers">42</a>
    </li>

        <li>
          <a href="/dreamcat4/CmdMessenger/fork" class="minibutton js-toggler-target fork-button lighter upwards" title="Fork this repo" rel="nofollow" data-method="post">
            <span class="mini-icon mini-icon-branch-create"></span>
            <span class="text">Fork</span>
          </a>
          <a href="/dreamcat4/CmdMessenger/network" class="social-count">6</a>
        </li>


</ul>

              <h1 itemscope itemtype="http://data-vocabulary.org/Breadcrumb" class="entry-title public">
                <span class="repo-label"><span>public</span></span>
                <span class="mega-icon mega-icon-public-repo"></span>
                <span class="author vcard">
                  <a href="/dreamcat4" class="url fn" itemprop="url" rel="author">
                  <span itemprop="title">dreamcat4</span>
                  </a></span> /
                <strong><a href="/dreamcat4/CmdMessenger" class="js-current-repository">CmdMessenger</a></strong>
              </h1>
            </div>

            
  <ul class="tabs">
    <li><a href="/dreamcat4/CmdMessenger" class="selected" highlight="repo_source repo_downloads repo_commits repo_tags repo_branches">Code</a></li>
    <li><a href="/dreamcat4/CmdMessenger/network" highlight="repo_network">Network</a></li>
    <li><a href="/dreamcat4/CmdMessenger/pulls" highlight="repo_pulls">Pull Requests <span class='counter'>0</span></a></li>

      <li><a href="/dreamcat4/CmdMessenger/issues" highlight="repo_issues">Issues <span class='counter'>0</span></a></li>

      <li><a href="/dreamcat4/CmdMessenger/wiki" highlight="repo_wiki">Wiki</a></li>


    <li><a href="/dreamcat4/CmdMessenger/graphs" highlight="repo_graphs repo_contributors">Graphs</a></li>


  </ul>
  
<div class="tabnav">

  <span class="tabnav-right">
    <ul class="tabnav-tabs">
          <li><a href="/dreamcat4/CmdMessenger/tags" class="tabnav-tab" highlight="repo_tags">Tags <span class="counter ">5</span></a></li>
    </ul>
    
  </span>

  <div class="tabnav-widget scope">


    <div class="select-menu js-menu-container js-select-menu js-branch-menu">
      <a class="minibutton select-menu-button js-menu-target" data-hotkey="w" data-ref="master">
        <span class="mini-icon mini-icon-branch"></span>
        <i>branch:</i>
        <span class="js-select-button">master</span>
      </a>

      <div class="select-menu-modal-holder js-menu-content js-navigation-container">

        <div class="select-menu-modal">
          <div class="select-menu-header">
            <span class="select-menu-title">Switch branches/tags</span>
            <span class="mini-icon mini-icon-remove-close js-menu-close"></span>
          </div> <!-- /.select-menu-header -->

          <div class="select-menu-filters">
            <div class="select-menu-text-filter">
              <input type="text" id="commitish-filter-field" class="js-filterable-field js-navigation-enable" placeholder="Filter branches/tags">
            </div>
            <div class="select-menu-tabs">
              <ul>
                <li class="select-menu-tab">
                  <a href="#" data-tab-filter="branches" class="js-select-menu-tab">Branches</a>
                </li>
                <li class="select-menu-tab">
                  <a href="#" data-tab-filter="tags" class="js-select-menu-tab">Tags</a>
                </li>
              </ul>
            </div><!-- /.select-menu-tabs -->
          </div><!-- /.select-menu-filters -->

          <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket css-truncate" data-tab-filter="branches">

            <div data-filterable-for="commitish-filter-field" data-filterable-type="substring">

                <div class="select-menu-item js-navigation-item js-navigation-target selected">
                  <span class="select-menu-item-icon mini-icon mini-icon-confirm"></span>
                  <a href="/dreamcat4/CmdMessenger/blob/master/CmdMessenger.cpp" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="master" rel="nofollow" title="master">master</a>
                </div> <!-- /.select-menu-item -->
            </div>

              <div class="select-menu-no-results">Nothing to show</div>
          </div> <!-- /.select-menu-list -->


          <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket css-truncate" data-tab-filter="tags">
            <div data-filterable-for="commitish-filter-field" data-filterable-type="substring">

                <div class="select-menu-item js-navigation-item js-navigation-target ">
                  <span class="select-menu-item-icon mini-icon mini-icon-confirm"></span>
                  <a href="/dreamcat4/CmdMessenger/blob/v2.20/CmdMessenger.cpp" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="v2.20" rel="nofollow" title="v2.20">v2.20</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item js-navigation-target ">
                  <span class="select-menu-item-icon mini-icon mini-icon-confirm"></span>
                  <a href="/dreamcat4/CmdMessenger/blob/v2.10/CmdMessenger.cpp" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="v2.10" rel="nofollow" title="v2.10">v2.10</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item js-navigation-target ">
                  <span class="select-menu-item-icon mini-icon mini-icon-confirm"></span>
                  <a href="/dreamcat4/CmdMessenger/blob/v2.05/CmdMessenger.cpp" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="v2.05" rel="nofollow" title="v2.05">v2.05</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item js-navigation-target ">
                  <span class="select-menu-item-icon mini-icon mini-icon-confirm"></span>
                  <a href="/dreamcat4/CmdMessenger/blob/v2.00/CmdMessenger.cpp" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="v2.00" rel="nofollow" title="v2.00">v2.00</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item js-navigation-target ">
                  <span class="select-menu-item-icon mini-icon mini-icon-confirm"></span>
                  <a href="/dreamcat4/CmdMessenger/blob/v0.10/CmdMessenger.cpp" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="v0.10" rel="nofollow" title="v0.10">v0.10</a>
                </div> <!-- /.select-menu-item -->
            </div>

            <div class="select-menu-no-results">Nothing to show</div>

          </div> <!-- /.select-menu-list -->

        </div> <!-- /.select-menu-modal -->
      </div> <!-- /.select-menu-modal-holder -->
    </div> <!-- /.select-menu -->

  </div> <!-- /.scope -->

  <ul class="tabnav-tabs">
    <li><a href="/dreamcat4/CmdMessenger" class="selected tabnav-tab" highlight="repo_source">Files</a></li>
    <li><a href="/dreamcat4/CmdMessenger/commits/master" class="tabnav-tab" highlight="repo_commits">Commits</a></li>
    <li><a href="/dreamcat4/CmdMessenger/branches" class="tabnav-tab" highlight="repo_branches" rel="nofollow">Branches <span class="counter ">1</span></a></li>
  </ul>

</div>

  
  
  


            
          </div>
        </div><!-- /.repohead -->

        <div id="js-repo-pjax-container" class="container context-loader-container" data-pjax-container>
          


<!-- blob contrib key: blob_contributors:v21:18980c0b78751bf7f398e3ca964020b0 -->
<!-- blob contrib frag key: views10/v8/blob_contributors:v21:18980c0b78751bf7f398e3ca964020b0 -->


<div id="slider">
    <div class="frame-meta">

      <p title="This is a placeholder element" class="js-history-link-replace hidden"></p>

        <div class="breadcrumb">
          <span class='bold'><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/dreamcat4/CmdMessenger" class="js-slide-to" data-branch="master" data-direction="back" itemscope="url"><span itemprop="title">CmdMessenger</span></a></span></span><span class="separator"> / </span><strong class="final-path">CmdMessenger.cpp</strong> <span class="js-zeroclipboard zeroclipboard-button" data-clipboard-text="CmdMessenger.cpp" data-copied-hint="copied!" title="copy to clipboard"><span class="mini-icon mini-icon-clipboard"></span></span>
        </div>

      <a href="/dreamcat4/CmdMessenger/find/master" class="js-slide-to" data-hotkey="t" style="display:none">Show File Finder</a>


        
  <div class="commit file-history-tease">
    <img class="main-avatar" height="24" src="https://secure.gravatar.com/avatar/373aea769d4accb42aeb1cffaa935774?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="24" />
    <span class="author"><a href="/dreamcat4" rel="author">dreamcat4</a></span>
    <time class="js-relative-date" datetime="2011-03-23T11:33:48-07:00" title="2011-03-23 11:33:48">March 23, 2011</time>
    <div class="commit-title">
        <a href="/dreamcat4/CmdMessenger/commit/4a0794721b62f18aa8522e4e9f915c3a3d4c18ce" class="message">Add cmd seperator to outgoing messages</a>
    </div>

    <div class="participation">
      <p class="quickstat"><a href="#blob_contributors_box" rel="facebox"><strong>1</strong> contributor</a></p>
      
    </div>
    <div id="blob_contributors_box" style="display:none">
      <h2>Users on GitHub who have contributed to this file</h2>
      <ul class="facebox-user-list">
        <li>
          <img height="24" src="https://secure.gravatar.com/avatar/373aea769d4accb42aeb1cffaa935774?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="24" />
          <a href="/dreamcat4">dreamcat4</a>
        </li>
      </ul>
    </div>
  </div>


    </div><!-- ./.frame-meta -->

    <div class="frames">
      <div class="frame" data-permalink-url="/dreamcat4/CmdMessenger/blob/2aa7caa3beadb2257ec811b04b9e4983f78ee80d/CmdMessenger.cpp" data-title="CmdMessenger/CmdMessenger.cpp at master · dreamcat4/CmdMessenger · GitHub" data-type="blob">

        <div id="files" class="bubble">
          <div class="file">
            <div class="meta">
              <div class="info">
                <span class="icon"><b class="mini-icon mini-icon-text-file"></b></span>
                <span class="mode" title="File Mode">file</span>
                  <span>266 lines (228 sloc)</span>
                <span>5.564 kb</span>
              </div>
              <div class="actions">
                <div class="button-group">
                        <a class="minibutton tooltipped leftwards"
                           title="Clicking this button will automatically fork this project so you can edit the file"
                           href="/dreamcat4/CmdMessenger/edit/master/CmdMessenger.cpp"
                           data-method="post" rel="nofollow">Edit</a>
                  <a href="/dreamcat4/CmdMessenger/raw/master/CmdMessenger.cpp" class="button minibutton " id="raw-url">Raw</a>
                    <a href="/dreamcat4/CmdMessenger/blame/master/CmdMessenger.cpp" class="button minibutton ">Blame</a>
                  <a href="/dreamcat4/CmdMessenger/commits/master/CmdMessenger.cpp" class="button minibutton " rel="nofollow">History</a>
                </div><!-- /.button-group -->
              </div><!-- /.actions -->

            </div>
                <div class="data type-c js-blob-data">
      <table cellpadding="0" cellspacing="0" class="lines">
        <tr>
          <td>
            <pre class="line_numbers"><span id="L1" rel="#L1">1</span>
<span id="L2" rel="#L2">2</span>
<span id="L3" rel="#L3">3</span>
<span id="L4" rel="#L4">4</span>
<span id="L5" rel="#L5">5</span>
<span id="L6" rel="#L6">6</span>
<span id="L7" rel="#L7">7</span>
<span id="L8" rel="#L8">8</span>
<span id="L9" rel="#L9">9</span>
<span id="L10" rel="#L10">10</span>
<span id="L11" rel="#L11">11</span>
<span id="L12" rel="#L12">12</span>
<span id="L13" rel="#L13">13</span>
<span id="L14" rel="#L14">14</span>
<span id="L15" rel="#L15">15</span>
<span id="L16" rel="#L16">16</span>
<span id="L17" rel="#L17">17</span>
<span id="L18" rel="#L18">18</span>
<span id="L19" rel="#L19">19</span>
<span id="L20" rel="#L20">20</span>
<span id="L21" rel="#L21">21</span>
<span id="L22" rel="#L22">22</span>
<span id="L23" rel="#L23">23</span>
<span id="L24" rel="#L24">24</span>
<span id="L25" rel="#L25">25</span>
<span id="L26" rel="#L26">26</span>
<span id="L27" rel="#L27">27</span>
<span id="L28" rel="#L28">28</span>
<span id="L29" rel="#L29">29</span>
<span id="L30" rel="#L30">30</span>
<span id="L31" rel="#L31">31</span>
<span id="L32" rel="#L32">32</span>
<span id="L33" rel="#L33">33</span>
<span id="L34" rel="#L34">34</span>
<span id="L35" rel="#L35">35</span>
<span id="L36" rel="#L36">36</span>
<span id="L37" rel="#L37">37</span>
<span id="L38" rel="#L38">38</span>
<span id="L39" rel="#L39">39</span>
<span id="L40" rel="#L40">40</span>
<span id="L41" rel="#L41">41</span>
<span id="L42" rel="#L42">42</span>
<span id="L43" rel="#L43">43</span>
<span id="L44" rel="#L44">44</span>
<span id="L45" rel="#L45">45</span>
<span id="L46" rel="#L46">46</span>
<span id="L47" rel="#L47">47</span>
<span id="L48" rel="#L48">48</span>
<span id="L49" rel="#L49">49</span>
<span id="L50" rel="#L50">50</span>
<span id="L51" rel="#L51">51</span>
<span id="L52" rel="#L52">52</span>
<span id="L53" rel="#L53">53</span>
<span id="L54" rel="#L54">54</span>
<span id="L55" rel="#L55">55</span>
<span id="L56" rel="#L56">56</span>
<span id="L57" rel="#L57">57</span>
<span id="L58" rel="#L58">58</span>
<span id="L59" rel="#L59">59</span>
<span id="L60" rel="#L60">60</span>
<span id="L61" rel="#L61">61</span>
<span id="L62" rel="#L62">62</span>
<span id="L63" rel="#L63">63</span>
<span id="L64" rel="#L64">64</span>
<span id="L65" rel="#L65">65</span>
<span id="L66" rel="#L66">66</span>
<span id="L67" rel="#L67">67</span>
<span id="L68" rel="#L68">68</span>
<span id="L69" rel="#L69">69</span>
<span id="L70" rel="#L70">70</span>
<span id="L71" rel="#L71">71</span>
<span id="L72" rel="#L72">72</span>
<span id="L73" rel="#L73">73</span>
<span id="L74" rel="#L74">74</span>
<span id="L75" rel="#L75">75</span>
<span id="L76" rel="#L76">76</span>
<span id="L77" rel="#L77">77</span>
<span id="L78" rel="#L78">78</span>
<span id="L79" rel="#L79">79</span>
<span id="L80" rel="#L80">80</span>
<span id="L81" rel="#L81">81</span>
<span id="L82" rel="#L82">82</span>
<span id="L83" rel="#L83">83</span>
<span id="L84" rel="#L84">84</span>
<span id="L85" rel="#L85">85</span>
<span id="L86" rel="#L86">86</span>
<span id="L87" rel="#L87">87</span>
<span id="L88" rel="#L88">88</span>
<span id="L89" rel="#L89">89</span>
<span id="L90" rel="#L90">90</span>
<span id="L91" rel="#L91">91</span>
<span id="L92" rel="#L92">92</span>
<span id="L93" rel="#L93">93</span>
<span id="L94" rel="#L94">94</span>
<span id="L95" rel="#L95">95</span>
<span id="L96" rel="#L96">96</span>
<span id="L97" rel="#L97">97</span>
<span id="L98" rel="#L98">98</span>
<span id="L99" rel="#L99">99</span>
<span id="L100" rel="#L100">100</span>
<span id="L101" rel="#L101">101</span>
<span id="L102" rel="#L102">102</span>
<span id="L103" rel="#L103">103</span>
<span id="L104" rel="#L104">104</span>
<span id="L105" rel="#L105">105</span>
<span id="L106" rel="#L106">106</span>
<span id="L107" rel="#L107">107</span>
<span id="L108" rel="#L108">108</span>
<span id="L109" rel="#L109">109</span>
<span id="L110" rel="#L110">110</span>
<span id="L111" rel="#L111">111</span>
<span id="L112" rel="#L112">112</span>
<span id="L113" rel="#L113">113</span>
<span id="L114" rel="#L114">114</span>
<span id="L115" rel="#L115">115</span>
<span id="L116" rel="#L116">116</span>
<span id="L117" rel="#L117">117</span>
<span id="L118" rel="#L118">118</span>
<span id="L119" rel="#L119">119</span>
<span id="L120" rel="#L120">120</span>
<span id="L121" rel="#L121">121</span>
<span id="L122" rel="#L122">122</span>
<span id="L123" rel="#L123">123</span>
<span id="L124" rel="#L124">124</span>
<span id="L125" rel="#L125">125</span>
<span id="L126" rel="#L126">126</span>
<span id="L127" rel="#L127">127</span>
<span id="L128" rel="#L128">128</span>
<span id="L129" rel="#L129">129</span>
<span id="L130" rel="#L130">130</span>
<span id="L131" rel="#L131">131</span>
<span id="L132" rel="#L132">132</span>
<span id="L133" rel="#L133">133</span>
<span id="L134" rel="#L134">134</span>
<span id="L135" rel="#L135">135</span>
<span id="L136" rel="#L136">136</span>
<span id="L137" rel="#L137">137</span>
<span id="L138" rel="#L138">138</span>
<span id="L139" rel="#L139">139</span>
<span id="L140" rel="#L140">140</span>
<span id="L141" rel="#L141">141</span>
<span id="L142" rel="#L142">142</span>
<span id="L143" rel="#L143">143</span>
<span id="L144" rel="#L144">144</span>
<span id="L145" rel="#L145">145</span>
<span id="L146" rel="#L146">146</span>
<span id="L147" rel="#L147">147</span>
<span id="L148" rel="#L148">148</span>
<span id="L149" rel="#L149">149</span>
<span id="L150" rel="#L150">150</span>
<span id="L151" rel="#L151">151</span>
<span id="L152" rel="#L152">152</span>
<span id="L153" rel="#L153">153</span>
<span id="L154" rel="#L154">154</span>
<span id="L155" rel="#L155">155</span>
<span id="L156" rel="#L156">156</span>
<span id="L157" rel="#L157">157</span>
<span id="L158" rel="#L158">158</span>
<span id="L159" rel="#L159">159</span>
<span id="L160" rel="#L160">160</span>
<span id="L161" rel="#L161">161</span>
<span id="L162" rel="#L162">162</span>
<span id="L163" rel="#L163">163</span>
<span id="L164" rel="#L164">164</span>
<span id="L165" rel="#L165">165</span>
<span id="L166" rel="#L166">166</span>
<span id="L167" rel="#L167">167</span>
<span id="L168" rel="#L168">168</span>
<span id="L169" rel="#L169">169</span>
<span id="L170" rel="#L170">170</span>
<span id="L171" rel="#L171">171</span>
<span id="L172" rel="#L172">172</span>
<span id="L173" rel="#L173">173</span>
<span id="L174" rel="#L174">174</span>
<span id="L175" rel="#L175">175</span>
<span id="L176" rel="#L176">176</span>
<span id="L177" rel="#L177">177</span>
<span id="L178" rel="#L178">178</span>
<span id="L179" rel="#L179">179</span>
<span id="L180" rel="#L180">180</span>
<span id="L181" rel="#L181">181</span>
<span id="L182" rel="#L182">182</span>
<span id="L183" rel="#L183">183</span>
<span id="L184" rel="#L184">184</span>
<span id="L185" rel="#L185">185</span>
<span id="L186" rel="#L186">186</span>
<span id="L187" rel="#L187">187</span>
<span id="L188" rel="#L188">188</span>
<span id="L189" rel="#L189">189</span>
<span id="L190" rel="#L190">190</span>
<span id="L191" rel="#L191">191</span>
<span id="L192" rel="#L192">192</span>
<span id="L193" rel="#L193">193</span>
<span id="L194" rel="#L194">194</span>
<span id="L195" rel="#L195">195</span>
<span id="L196" rel="#L196">196</span>
<span id="L197" rel="#L197">197</span>
<span id="L198" rel="#L198">198</span>
<span id="L199" rel="#L199">199</span>
<span id="L200" rel="#L200">200</span>
<span id="L201" rel="#L201">201</span>
<span id="L202" rel="#L202">202</span>
<span id="L203" rel="#L203">203</span>
<span id="L204" rel="#L204">204</span>
<span id="L205" rel="#L205">205</span>
<span id="L206" rel="#L206">206</span>
<span id="L207" rel="#L207">207</span>
<span id="L208" rel="#L208">208</span>
<span id="L209" rel="#L209">209</span>
<span id="L210" rel="#L210">210</span>
<span id="L211" rel="#L211">211</span>
<span id="L212" rel="#L212">212</span>
<span id="L213" rel="#L213">213</span>
<span id="L214" rel="#L214">214</span>
<span id="L215" rel="#L215">215</span>
<span id="L216" rel="#L216">216</span>
<span id="L217" rel="#L217">217</span>
<span id="L218" rel="#L218">218</span>
<span id="L219" rel="#L219">219</span>
<span id="L220" rel="#L220">220</span>
<span id="L221" rel="#L221">221</span>
<span id="L222" rel="#L222">222</span>
<span id="L223" rel="#L223">223</span>
<span id="L224" rel="#L224">224</span>
<span id="L225" rel="#L225">225</span>
<span id="L226" rel="#L226">226</span>
<span id="L227" rel="#L227">227</span>
<span id="L228" rel="#L228">228</span>
<span id="L229" rel="#L229">229</span>
<span id="L230" rel="#L230">230</span>
<span id="L231" rel="#L231">231</span>
<span id="L232" rel="#L232">232</span>
<span id="L233" rel="#L233">233</span>
<span id="L234" rel="#L234">234</span>
<span id="L235" rel="#L235">235</span>
<span id="L236" rel="#L236">236</span>
<span id="L237" rel="#L237">237</span>
<span id="L238" rel="#L238">238</span>
<span id="L239" rel="#L239">239</span>
<span id="L240" rel="#L240">240</span>
<span id="L241" rel="#L241">241</span>
<span id="L242" rel="#L242">242</span>
<span id="L243" rel="#L243">243</span>
<span id="L244" rel="#L244">244</span>
<span id="L245" rel="#L245">245</span>
<span id="L246" rel="#L246">246</span>
<span id="L247" rel="#L247">247</span>
<span id="L248" rel="#L248">248</span>
<span id="L249" rel="#L249">249</span>
<span id="L250" rel="#L250">250</span>
<span id="L251" rel="#L251">251</span>
<span id="L252" rel="#L252">252</span>
<span id="L253" rel="#L253">253</span>
<span id="L254" rel="#L254">254</span>
<span id="L255" rel="#L255">255</span>
<span id="L256" rel="#L256">256</span>
<span id="L257" rel="#L257">257</span>
<span id="L258" rel="#L258">258</span>
<span id="L259" rel="#L259">259</span>
<span id="L260" rel="#L260">260</span>
<span id="L261" rel="#L261">261</span>
<span id="L262" rel="#L262">262</span>
<span id="L263" rel="#L263">263</span>
<span id="L264" rel="#L264">264</span>
<span id="L265" rel="#L265">265</span>
</pre>
          </td>
          <td width="100%">
                  <div class="highlight"><pre><div class='line' id='LC1'><br/></div><div class='line' id='LC2'><span class="c1">// ADDED FOR COMPATIBILITY WITH WIRING ??</span></div><div class='line' id='LC3'><span class="k">extern</span> <span class="s">&quot;C&quot;</span> <span class="p">{</span></div><div class='line' id='LC4'>&nbsp;&nbsp;<span class="err">#</span><span class="n">include</span> <span class="o">&lt;</span><span class="n">stdlib</span><span class="p">.</span><span class="n">h</span><span class="o">&gt;</span></div><div class='line' id='LC5'><span class="p">}</span></div><div class='line' id='LC6'><br/></div><div class='line' id='LC7'><span class="cp">#include &quot;CmdMessenger.h&quot;</span></div><div class='line' id='LC8'><span class="cp">#include &lt;Streaming.h&gt;</span></div><div class='line' id='LC9'><br/></div><div class='line' id='LC10'><span class="c1">//////////////////// Cmd Messenger imp ////////////////</span></div><div class='line' id='LC11'><span class="n">CmdMessenger</span><span class="o">::</span><span class="n">CmdMessenger</span><span class="p">(</span><span class="n">Stream</span> <span class="o">&amp;</span><span class="n">ccomms</span><span class="p">)</span></div><div class='line' id='LC12'><span class="p">{</span></div><div class='line' id='LC13'>&nbsp;&nbsp;<span class="n">init</span><span class="p">(</span><span class="n">ccomms</span><span class="p">,</span><span class="sc">&#39; &#39;</span><span class="p">,</span><span class="sc">&#39;;&#39;</span><span class="p">);</span></div><div class='line' id='LC14'><span class="p">}</span></div><div class='line' id='LC15'><br/></div><div class='line' id='LC16'><span class="n">CmdMessenger</span><span class="o">::</span><span class="n">CmdMessenger</span><span class="p">(</span><span class="n">Stream</span> <span class="o">&amp;</span><span class="n">ccomms</span><span class="p">,</span> <span class="kt">char</span> <span class="n">fld_separator</span><span class="p">)</span></div><div class='line' id='LC17'><span class="p">{</span></div><div class='line' id='LC18'>&nbsp;&nbsp;<span class="n">init</span><span class="p">(</span><span class="n">ccomms</span><span class="p">,</span><span class="n">fld_separator</span><span class="p">,</span><span class="sc">&#39;;&#39;</span><span class="p">);</span></div><div class='line' id='LC19'><span class="p">}</span></div><div class='line' id='LC20'><br/></div><div class='line' id='LC21'><span class="n">CmdMessenger</span><span class="o">::</span><span class="n">CmdMessenger</span><span class="p">(</span><span class="n">Stream</span> <span class="o">&amp;</span><span class="n">ccomms</span><span class="p">,</span> <span class="kt">char</span> <span class="n">fld_separator</span><span class="p">,</span> <span class="kt">char</span> <span class="n">cmd_separator</span><span class="p">)</span></div><div class='line' id='LC22'><span class="p">{</span></div><div class='line' id='LC23'>&nbsp;&nbsp;<span class="n">init</span><span class="p">(</span><span class="n">ccomms</span><span class="p">,</span><span class="n">fld_separator</span><span class="p">,</span><span class="n">cmd_separator</span><span class="p">);</span></div><div class='line' id='LC24'><span class="p">}</span></div><div class='line' id='LC25'><br/></div><div class='line' id='LC26'><span class="kt">void</span> <span class="n">CmdMessenger</span><span class="o">::</span><span class="n">attach</span><span class="p">(</span><span class="n">messengerCallbackFunction</span> <span class="n">newFunction</span><span class="p">)</span> <span class="p">{</span></div><div class='line' id='LC27'>	<span class="n">default_callback</span> <span class="o">=</span> <span class="n">newFunction</span><span class="p">;</span></div><div class='line' id='LC28'><span class="p">}</span></div><div class='line' id='LC29'><br/></div><div class='line' id='LC30'><span class="kt">void</span> <span class="n">CmdMessenger</span><span class="o">::</span><span class="n">attach</span><span class="p">(</span><span class="n">byte</span> <span class="n">msgId</span><span class="p">,</span> <span class="n">messengerCallbackFunction</span> <span class="n">newFunction</span><span class="p">)</span> <span class="p">{</span></div><div class='line' id='LC31'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="p">(</span><span class="n">msgId</span> <span class="o">&gt;</span> <span class="mi">0</span> <span class="o">&amp;&amp;</span> <span class="n">msgId</span> <span class="o">&lt;=</span> <span class="n">MAXCALLBACKS</span><span class="p">)</span> <span class="c1">// &lt;= ? I think its ok ?</span></div><div class='line' id='LC32'>	<span class="n">callbackList</span><span class="p">[</span><span class="n">msgId</span><span class="o">-</span><span class="mi">1</span><span class="p">]</span> <span class="o">=</span> <span class="n">newFunction</span><span class="p">;</span></div><div class='line' id='LC33'><span class="p">}</span></div><div class='line' id='LC34'><br/></div><div class='line' id='LC35'><span class="kt">void</span> <span class="n">CmdMessenger</span><span class="o">::</span><span class="n">discard_LF_CR</span><span class="p">()</span></div><div class='line' id='LC36'><span class="p">{</span></div><div class='line' id='LC37'>&nbsp;&nbsp;<span class="n">discard_newlines</span> <span class="o">=</span> <span class="nb">true</span><span class="p">;</span></div><div class='line' id='LC38'><span class="p">}</span></div><div class='line' id='LC39'><br/></div><div class='line' id='LC40'><span class="kt">void</span> <span class="n">CmdMessenger</span><span class="o">::</span><span class="n">print_LF_CR</span><span class="p">()</span></div><div class='line' id='LC41'><span class="p">{</span></div><div class='line' id='LC42'>&nbsp;&nbsp;<span class="n">print_newlines</span>   <span class="o">=</span> <span class="nb">true</span><span class="p">;</span></div><div class='line' id='LC43'><span class="p">}</span></div><div class='line' id='LC44'><br/></div><div class='line' id='LC45'><span class="kt">void</span> <span class="n">CmdMessenger</span><span class="o">::</span><span class="n">init</span><span class="p">(</span><span class="n">Stream</span> <span class="o">&amp;</span><span class="n">ccomms</span><span class="p">,</span> <span class="kt">char</span> <span class="n">fld_separator</span><span class="p">,</span> <span class="kt">char</span> <span class="n">cmd_separator</span><span class="p">)</span></div><div class='line' id='LC46'><span class="p">{</span></div><div class='line' id='LC47'>&nbsp;&nbsp;<span class="n">comms</span> <span class="o">=</span> <span class="o">&amp;</span><span class="n">ccomms</span><span class="p">;</span></div><div class='line' id='LC48'>&nbsp;&nbsp;</div><div class='line' id='LC49'>&nbsp;&nbsp;<span class="n">discard_newlines</span> <span class="o">=</span> <span class="nb">false</span><span class="p">;</span></div><div class='line' id='LC50'>&nbsp;&nbsp;<span class="n">print_newlines</span>   <span class="o">=</span> <span class="nb">false</span><span class="p">;</span></div><div class='line' id='LC51'><br/></div><div class='line' id='LC52'>&nbsp;&nbsp;<span class="n">field_separator</span>   <span class="o">=</span> <span class="n">fld_separator</span><span class="p">;</span></div><div class='line' id='LC53'>&nbsp;&nbsp;<span class="n">command_separator</span> <span class="o">=</span> <span class="n">cmd_separator</span><span class="p">;</span></div><div class='line' id='LC54'><br/></div><div class='line' id='LC55'>&nbsp;&nbsp;<span class="n">bufferLength</span> <span class="o">=</span> <span class="n">MESSENGERBUFFERSIZE</span><span class="p">;</span></div><div class='line' id='LC56'>&nbsp;&nbsp;<span class="n">bufferLastIndex</span> <span class="o">=</span> <span class="n">MESSENGERBUFFERSIZE</span> <span class="o">-</span><span class="mi">1</span><span class="p">;</span></div><div class='line' id='LC57'>&nbsp;&nbsp;<span class="n">reset</span><span class="p">();</span></div><div class='line' id='LC58'><br/></div><div class='line' id='LC59'>&nbsp;&nbsp;<span class="n">default_callback</span> <span class="o">=</span> <span class="nb">NULL</span><span class="p">;</span></div><div class='line' id='LC60'>&nbsp;&nbsp;<span class="k">for</span> <span class="p">(</span><span class="kt">int</span> <span class="n">i</span> <span class="o">=</span> <span class="mi">0</span><span class="p">;</span> <span class="n">i</span> <span class="o">&lt;</span> <span class="n">MAXCALLBACKS</span><span class="p">;</span> <span class="n">i</span><span class="o">++</span><span class="p">)</span></div><div class='line' id='LC61'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">callbackList</span><span class="p">[</span><span class="n">i</span><span class="p">]</span> <span class="o">=</span> <span class="nb">NULL</span><span class="p">;</span></div><div class='line' id='LC62'><br/></div><div class='line' id='LC63'>&nbsp;&nbsp;<span class="n">pauseProcessing</span> <span class="o">=</span> <span class="nb">false</span><span class="p">;</span></div><div class='line' id='LC64'><span class="p">}</span></div><div class='line' id='LC65'><br/></div><div class='line' id='LC66'><span class="kt">void</span> <span class="n">CmdMessenger</span><span class="o">::</span><span class="n">reset</span><span class="p">()</span> <span class="p">{</span></div><div class='line' id='LC67'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">bufferIndex</span> <span class="o">=</span> <span class="mi">0</span><span class="p">;</span></div><div class='line' id='LC68'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">current</span> <span class="o">=</span> <span class="nb">NULL</span><span class="p">;</span></div><div class='line' id='LC69'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">last</span> <span class="o">=</span> <span class="nb">NULL</span><span class="p">;</span></div><div class='line' id='LC70'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">dumped</span> <span class="o">=</span> <span class="mi">1</span><span class="p">;</span></div><div class='line' id='LC71'><span class="p">}</span></div><div class='line' id='LC72'><br/></div><div class='line' id='LC73'><span class="kt">uint8_t</span> <span class="n">CmdMessenger</span><span class="o">::</span><span class="n">next</span><span class="p">()</span></div><div class='line' id='LC74'><span class="p">{</span></div><div class='line' id='LC75'>&nbsp;&nbsp;<span class="kt">char</span> <span class="o">*</span> <span class="n">temppointer</span><span class="o">=</span> <span class="nb">NULL</span><span class="p">;</span></div><div class='line' id='LC76'>&nbsp;&nbsp;<span class="c1">// Currently, cmd messenger only supports 1 char for the field seperator</span></div><div class='line' id='LC77'>&nbsp;&nbsp;<span class="k">const</span> <span class="kt">char</span> <span class="n">seperator_tokens</span><span class="p">[]</span> <span class="o">=</span> <span class="p">{</span> <span class="n">field_separator</span><span class="p">,</span><span class="sc">&#39;\0&#39;</span> <span class="p">};</span></div><div class='line' id='LC78'>&nbsp;&nbsp;<span class="k">switch</span> <span class="p">(</span><span class="n">messageState</span><span class="p">)</span></div><div class='line' id='LC79'>&nbsp;&nbsp;<span class="p">{</span></div><div class='line' id='LC80'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">case</span> <span class="mi">0</span>:</div><div class='line' id='LC81'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">return</span> <span class="mi">0</span><span class="p">;</span></div><div class='line' id='LC82'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">case</span> <span class="mi">1</span>:</div><div class='line' id='LC83'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">temppointer</span> <span class="o">=</span> <span class="n">buffer</span><span class="p">;</span></div><div class='line' id='LC84'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">messageState</span> <span class="o">=</span> <span class="mi">2</span><span class="p">;</span></div><div class='line' id='LC85'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nl">default:</span></div><div class='line' id='LC86'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="p">(</span><span class="n">dumped</span><span class="p">)</span></div><div class='line' id='LC87'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">current</span> <span class="o">=</span> <span class="n">strtok_r</span><span class="p">(</span><span class="n">temppointer</span><span class="p">,</span><span class="n">seperator_tokens</span><span class="p">,</span><span class="o">&amp;</span><span class="n">last</span><span class="p">);</span></div><div class='line' id='LC88'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="p">(</span><span class="n">current</span> <span class="o">!=</span> <span class="nb">NULL</span><span class="p">)</span></div><div class='line' id='LC89'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">{</span></div><div class='line' id='LC90'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">dumped</span> <span class="o">=</span> <span class="mi">0</span><span class="p">;</span></div><div class='line' id='LC91'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">return</span> <span class="mi">1</span><span class="p">;</span> </div><div class='line' id='LC92'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">}</span></div><div class='line' id='LC93'>&nbsp;&nbsp;<span class="p">}</span></div><div class='line' id='LC94'>&nbsp;&nbsp;<span class="k">return</span> <span class="mi">0</span><span class="p">;</span></div><div class='line' id='LC95'><span class="p">}</span></div><div class='line' id='LC96'><br/></div><div class='line' id='LC97'><span class="kt">uint8_t</span> <span class="n">CmdMessenger</span><span class="o">::</span><span class="n">available</span><span class="p">()</span></div><div class='line' id='LC98'><span class="p">{</span></div><div class='line' id='LC99'>&nbsp;&nbsp;<span class="k">return</span> <span class="n">next</span><span class="p">();</span></div><div class='line' id='LC100'><span class="p">}</span></div><div class='line' id='LC101'><br/></div><div class='line' id='LC102'><span class="kt">uint8_t</span> <span class="n">CmdMessenger</span><span class="o">::</span><span class="n">process</span><span class="p">(</span><span class="kt">int</span> <span class="n">serialByte</span><span class="p">)</span> <span class="p">{</span></div><div class='line' id='LC103'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">messageState</span> <span class="o">=</span> <span class="mi">0</span><span class="p">;</span></div><div class='line' id='LC104'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="kt">char</span> <span class="n">serialChar</span> <span class="o">=</span> <span class="p">(</span><span class="kt">char</span><span class="p">)</span><span class="n">serialByte</span><span class="p">;</span></div><div class='line' id='LC105'><br/></div><div class='line' id='LC106'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="p">(</span><span class="n">serialByte</span> <span class="o">&gt;</span> <span class="mi">0</span><span class="p">)</span> <span class="p">{</span></div><div class='line' id='LC107'><br/></div><div class='line' id='LC108'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c1">// Currently, cmd messenger only supports 1 char for the command seperator</span></div><div class='line' id='LC109'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span><span class="p">(</span><span class="n">serialChar</span> <span class="o">==</span> <span class="n">command_separator</span><span class="p">)</span></div><div class='line' id='LC110'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">{</span></div><div class='line' id='LC111'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">buffer</span><span class="p">[</span><span class="n">bufferIndex</span><span class="p">]</span><span class="o">=</span><span class="mi">0</span><span class="p">;</span></div><div class='line' id='LC112'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span><span class="p">(</span><span class="n">bufferIndex</span> <span class="o">&gt;</span> <span class="mi">0</span><span class="p">)</span></div><div class='line' id='LC113'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">{</span></div><div class='line' id='LC114'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">messageState</span> <span class="o">=</span> <span class="mi">1</span><span class="p">;</span></div><div class='line' id='LC115'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">current</span> <span class="o">=</span> <span class="n">buffer</span><span class="p">;</span></div><div class='line' id='LC116'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">}</span></div><div class='line' id='LC117'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">reset</span><span class="p">();</span></div><div class='line' id='LC118'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">}</span></div><div class='line' id='LC119'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">else</span></div><div class='line' id='LC120'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">{</span></div><div class='line' id='LC121'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">buffer</span><span class="p">[</span><span class="n">bufferIndex</span><span class="p">]</span><span class="o">=</span><span class="n">serialByte</span><span class="p">;</span></div><div class='line' id='LC122'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">bufferIndex</span><span class="o">++</span><span class="p">;</span></div><div class='line' id='LC123'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="p">(</span><span class="n">bufferIndex</span> <span class="o">&gt;=</span> <span class="n">bufferLastIndex</span><span class="p">)</span> <span class="n">reset</span><span class="p">();</span></div><div class='line' id='LC124'><br/></div><div class='line' id='LC125'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span><span class="p">(</span><span class="n">discard_newlines</span> <span class="o">&amp;&amp;</span> <span class="p">(</span><span class="n">serialChar</span> <span class="o">!=</span> <span class="n">field_separator</span><span class="p">))</span></div><div class='line' id='LC126'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span><span class="p">((</span><span class="n">serialChar</span> <span class="o">==</span> <span class="sc">&#39;\n&#39;</span><span class="p">)</span> <span class="o">||</span> <span class="p">(</span><span class="n">serialChar</span> <span class="o">==</span> <span class="sc">&#39;\r&#39;</span><span class="p">))</span></div><div class='line' id='LC127'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">reset</span><span class="p">();</span></div><div class='line' id='LC128'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">}</span></div><div class='line' id='LC129'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">}</span></div><div class='line' id='LC130'><br/></div><div class='line' id='LC131'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="p">(</span> <span class="n">messageState</span> <span class="o">==</span> <span class="mi">1</span> <span class="p">)</span> <span class="p">{</span></div><div class='line' id='LC132'>&nbsp;&nbsp;&nbsp;&nbsp;	<span class="n">handleMessage</span><span class="p">();</span></div><div class='line' id='LC133'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">}</span></div><div class='line' id='LC134'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">return</span> <span class="n">messageState</span><span class="p">;</span></div><div class='line' id='LC135'><span class="p">}</span></div><div class='line' id='LC136'><br/></div><div class='line' id='LC137'><span class="kt">void</span> <span class="n">CmdMessenger</span><span class="o">::</span><span class="n">handleMessage</span><span class="p">()</span></div><div class='line' id='LC138'><span class="p">{</span></div><div class='line' id='LC139'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="c1">// If we didnt want to use ASCII integer...</span></div><div class='line' id='LC140'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="c1">// we would change the line below vv</span></div><div class='line' id='LC141'>	<span class="kt">int</span> <span class="n">id</span> <span class="o">=</span> <span class="n">readInt</span><span class="p">();</span></div><div class='line' id='LC142'><br/></div><div class='line' id='LC143'>	<span class="c1">//Serial &lt;&lt; &quot;ID+&quot; &lt;&lt; id &lt;&lt; endl;</span></div><div class='line' id='LC144'>	<span class="c1">// Because readInt() can fail and return a 0 we can&#39;t</span></div><div class='line' id='LC145'>	<span class="c1">// start our array index at that number</span></div><div class='line' id='LC146'>	<span class="k">if</span> <span class="p">(</span><span class="n">id</span> <span class="o">&gt;</span> <span class="mi">0</span> <span class="o">&amp;&amp;</span> <span class="n">id</span> <span class="o">&lt;=</span> <span class="n">MAXCALLBACKS</span> <span class="o">&amp;&amp;</span> <span class="n">callbackList</span><span class="p">[</span><span class="n">id</span><span class="o">-</span><span class="mi">1</span><span class="p">]</span> <span class="o">!=</span> <span class="nb">NULL</span><span class="p">)</span></div><div class='line' id='LC147'>	  <span class="p">(</span><span class="o">*</span><span class="n">callbackList</span><span class="p">[</span><span class="n">id</span><span class="o">-</span><span class="mi">1</span><span class="p">])();</span></div><div class='line' id='LC148'>	<span class="k">else</span> <span class="c1">// Cmd not registered default callback</span></div><div class='line' id='LC149'>	  <span class="p">(</span><span class="o">*</span><span class="n">default_callback</span><span class="p">)();</span></div><div class='line' id='LC150'><span class="p">}</span></div><div class='line' id='LC151'><br/></div><div class='line' id='LC152'><span class="kt">void</span> <span class="n">CmdMessenger</span><span class="o">::</span><span class="n">feedinSerialData</span><span class="p">()</span></div><div class='line' id='LC153'><span class="p">{</span></div><div class='line' id='LC154'>&nbsp;&nbsp;<span class="k">while</span> <span class="p">(</span> <span class="o">!</span><span class="n">pauseProcessing</span> <span class="o">&amp;&amp;</span> <span class="n">comms</span><span class="o">-&gt;</span><span class="n">available</span><span class="p">(</span> <span class="p">)</span> <span class="p">)</span> </div><div class='line' id='LC155'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">process</span><span class="p">(</span><span class="n">comms</span><span class="o">-&gt;</span><span class="n">read</span><span class="p">(</span> <span class="p">)</span> <span class="p">);</span></div><div class='line' id='LC156'><span class="p">}</span></div><div class='line' id='LC157'><br/></div><div class='line' id='LC158'><span class="n">boolean</span> <span class="n">CmdMessenger</span><span class="o">::</span><span class="n">blockedTillReply</span><span class="p">(</span><span class="kt">int</span> <span class="n">timeout</span><span class="p">)</span></div><div class='line' id='LC159'><span class="p">{</span></div><div class='line' id='LC160'>&nbsp;&nbsp;<span class="kt">unsigned</span> <span class="kt">long</span> <span class="n">start</span> <span class="o">=</span> <span class="n">millis</span><span class="p">();</span></div><div class='line' id='LC161'>&nbsp;&nbsp;<span class="kt">unsigned</span> <span class="kt">long</span> <span class="n">time</span> <span class="o">=</span> <span class="n">start</span><span class="p">;</span></div><div class='line' id='LC162'>&nbsp;&nbsp;<span class="k">while</span><span class="p">(</span><span class="o">!</span><span class="n">comms</span><span class="o">-&gt;</span><span class="n">available</span><span class="p">()</span> <span class="o">||</span> <span class="p">(</span><span class="n">start</span> <span class="o">-</span> <span class="n">time</span><span class="p">)</span> <span class="o">&gt;</span> <span class="n">timeout</span> <span class="p">)</span></div><div class='line' id='LC163'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">time</span> <span class="o">=</span> <span class="n">millis</span><span class="p">();</span></div><div class='line' id='LC164'><span class="p">}</span></div><div class='line' id='LC165'><br/></div><div class='line' id='LC166'><span class="c1">// if the arguments in the future could be passed in as int/long/float etc</span></div><div class='line' id='LC167'><span class="c1">// then it might make sense to use the above writeReal????() methods</span></div><div class='line' id='LC168'><span class="c1">// I&#39;ve removed them for now.</span></div><div class='line' id='LC169'><span class="kt">char</span><span class="o">*</span> <span class="n">CmdMessenger</span><span class="o">::</span><span class="n">sendCmd</span><span class="p">(</span><span class="kt">int</span> <span class="n">cmdId</span><span class="p">,</span> <span class="kt">char</span> <span class="o">*</span><span class="n">msg</span><span class="p">,</span> <span class="n">boolean</span> <span class="n">reqAc</span><span class="p">,</span> </div><div class='line' id='LC170'>			       <span class="kt">char</span> <span class="o">*</span><span class="n">replyBuff</span><span class="p">,</span> <span class="kt">int</span> <span class="n">butSize</span><span class="p">,</span> <span class="kt">int</span> <span class="n">timeout</span><span class="p">,</span> </div><div class='line' id='LC171'>			       <span class="kt">int</span> <span class="n">retryCount</span><span class="p">)</span></div><div class='line' id='LC172'><span class="p">{</span></div><div class='line' id='LC173'>&nbsp;&nbsp;<span class="kt">int</span> <span class="n">tryCount</span> <span class="o">=</span> <span class="mi">0</span><span class="p">;</span>  </div><div class='line' id='LC174'>&nbsp;&nbsp;<span class="n">pauseProcessing</span> <span class="o">=</span> <span class="nb">true</span><span class="p">;</span></div><div class='line' id='LC175'>&nbsp;&nbsp;<span class="c1">//*comms &lt;&lt; cmdId &lt;&lt; field_separator &lt;&lt; msg &lt;&lt; endl;</span></div><div class='line' id='LC176'>&nbsp;&nbsp;<span class="n">comms</span><span class="o">-&gt;</span><span class="n">print</span><span class="p">(</span><span class="n">cmdId</span><span class="p">);</span></div><div class='line' id='LC177'>&nbsp;&nbsp;<span class="n">comms</span><span class="o">-&gt;</span><span class="n">print</span><span class="p">(</span><span class="n">field_separator</span><span class="p">);</span></div><div class='line' id='LC178'>&nbsp;&nbsp;<span class="n">comms</span><span class="o">-&gt;</span><span class="n">print</span><span class="p">(</span><span class="n">msg</span><span class="p">);</span></div><div class='line' id='LC179'>&nbsp;&nbsp;<span class="n">comms</span><span class="o">-&gt;</span><span class="n">print</span><span class="p">(</span><span class="n">command_separator</span><span class="p">);</span></div><div class='line' id='LC180'>&nbsp;&nbsp;<span class="k">if</span><span class="p">(</span><span class="n">print_newlines</span><span class="p">)</span></div><div class='line' id='LC181'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">comms</span><span class="o">-&gt;</span><span class="n">println</span><span class="p">();</span> <span class="c1">// should append BOTH \r\n</span></div><div class='line' id='LC182'>&nbsp;&nbsp;<span class="k">if</span> <span class="p">(</span><span class="n">reqAc</span><span class="p">)</span> <span class="p">{</span>    </div><div class='line' id='LC183'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">do</span> <span class="p">{</span></div><div class='line' id='LC184'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">blockedTillReply</span><span class="p">(</span><span class="n">timeout</span><span class="p">);</span></div><div class='line' id='LC185'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="c1">//strcpy(replyBuff, buf;</span></div><div class='line' id='LC186'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">}</span> <span class="k">while</span><span class="p">(</span> <span class="n">tryCount</span> <span class="o">&lt;</span> <span class="n">retryCount</span><span class="p">);</span></div><div class='line' id='LC187'>&nbsp;&nbsp;<span class="p">}</span></div><div class='line' id='LC188'>&nbsp;&nbsp;</div><div class='line' id='LC189'>&nbsp;&nbsp;<span class="n">pauseProcessing</span> <span class="o">=</span> <span class="nb">false</span><span class="p">;</span></div><div class='line' id='LC190'>&nbsp;&nbsp;<span class="k">return</span> <span class="nb">NULL</span><span class="p">;</span></div><div class='line' id='LC191'><span class="p">}</span></div><div class='line' id='LC192'><br/></div><div class='line' id='LC193'><br/></div><div class='line' id='LC194'><span class="c1">// Not sure if it will work for signed.. check it out</span></div><div class='line' id='LC195'><span class="cm">/*unsigned char *CmdMessenger::writeRealInt(int val, unsigned char buff[2])</span></div><div class='line' id='LC196'><span class="cm">{</span></div><div class='line' id='LC197'><span class="cm">  buff[1] = (unsigned char)val;</span></div><div class='line' id='LC198'><span class="cm">  buff[0] = (unsigned char)(val &gt;&gt; 8);  </span></div><div class='line' id='LC199'><span class="cm">  buff[2] = 0;</span></div><div class='line' id='LC200'><span class="cm">  return buff;</span></div><div class='line' id='LC201'><span class="cm">}</span></div><div class='line' id='LC202'><br/></div><div class='line' id='LC203'><span class="cm">char* CmdMessenger::writeRealLong(long val, char buff[4])</span></div><div class='line' id='LC204'><span class="cm">{</span></div><div class='line' id='LC205'><span class="cm">  //buff[1] = (unsigned char)val;</span></div><div class='line' id='LC206'><span class="cm">  //buff[0] = (unsigned char)(val &gt;&gt; 8);  </span></div><div class='line' id='LC207'><span class="cm">  return buff;</span></div><div class='line' id='LC208'><span class="cm">}</span></div><div class='line' id='LC209'><br/></div><div class='line' id='LC210'><span class="cm">char* CmdMessenger::writeRealFloat(float val, char buff[4])</span></div><div class='line' id='LC211'><span class="cm">{</span></div><div class='line' id='LC212'><span class="cm">  //buff[1] = (unsigned char)val;</span></div><div class='line' id='LC213'><span class="cm">  //buff[0] = (unsigned char)(val &gt;&gt; 8);  </span></div><div class='line' id='LC214'><span class="cm">  return buff;</span></div><div class='line' id='LC215'><span class="cm">}</span></div><div class='line' id='LC216'><span class="cm">*/</span></div><div class='line' id='LC217'><br/></div><div class='line' id='LC218'><span class="kt">int</span> <span class="n">CmdMessenger</span><span class="o">::</span><span class="n">readInt</span><span class="p">()</span></div><div class='line' id='LC219'><span class="p">{</span></div><div class='line' id='LC220'>&nbsp;&nbsp;<span class="k">if</span> <span class="p">(</span><span class="n">next</span><span class="p">())</span></div><div class='line' id='LC221'>&nbsp;&nbsp;<span class="p">{</span></div><div class='line' id='LC222'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">dumped</span> <span class="o">=</span> <span class="mi">1</span><span class="p">;</span></div><div class='line' id='LC223'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">return</span> <span class="nf">atoi</span><span class="p">(</span><span class="n">current</span><span class="p">);</span></div><div class='line' id='LC224'>&nbsp;&nbsp;<span class="p">}</span></div><div class='line' id='LC225'>&nbsp;&nbsp;<span class="k">return</span> <span class="mi">0</span><span class="p">;</span></div><div class='line' id='LC226'><span class="p">}</span></div><div class='line' id='LC227'><br/></div><div class='line' id='LC228'><span class="kt">char</span> <span class="n">CmdMessenger</span><span class="o">::</span><span class="n">readChar</span><span class="p">()</span></div><div class='line' id='LC229'><span class="p">{</span></div><div class='line' id='LC230'>&nbsp;&nbsp;<span class="k">if</span> <span class="p">(</span><span class="n">next</span><span class="p">())</span></div><div class='line' id='LC231'>&nbsp;&nbsp;<span class="p">{</span></div><div class='line' id='LC232'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">dumped</span> <span class="o">=</span> <span class="mi">1</span><span class="p">;</span></div><div class='line' id='LC233'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">return</span> <span class="n">current</span><span class="p">[</span><span class="mi">0</span><span class="p">];</span></div><div class='line' id='LC234'>&nbsp;&nbsp;<span class="p">}</span></div><div class='line' id='LC235'>&nbsp;&nbsp;<span class="k">return</span> <span class="mi">0</span><span class="p">;</span></div><div class='line' id='LC236'><span class="p">}</span></div><div class='line' id='LC237'><br/></div><div class='line' id='LC238'><span class="kt">void</span> <span class="n">CmdMessenger</span><span class="o">::</span><span class="n">copyString</span><span class="p">(</span><span class="kt">char</span> <span class="o">*</span><span class="n">string</span><span class="p">,</span> <span class="kt">uint8_t</span> <span class="n">size</span><span class="p">)</span></div><div class='line' id='LC239'><span class="p">{</span></div><div class='line' id='LC240'>&nbsp;&nbsp;<span class="k">if</span> <span class="p">(</span><span class="n">next</span><span class="p">())</span></div><div class='line' id='LC241'>&nbsp;&nbsp;<span class="p">{</span></div><div class='line' id='LC242'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">dumped</span> <span class="o">=</span> <span class="mi">1</span><span class="p">;</span></div><div class='line' id='LC243'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">strlcpy</span><span class="p">(</span><span class="n">string</span><span class="p">,</span><span class="n">current</span><span class="p">,</span><span class="n">size</span><span class="p">);</span></div><div class='line' id='LC244'>&nbsp;&nbsp;<span class="p">}</span></div><div class='line' id='LC245'>&nbsp;&nbsp;<span class="k">else</span></div><div class='line' id='LC246'>&nbsp;&nbsp;<span class="p">{</span></div><div class='line' id='LC247'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="p">(</span> <span class="n">size</span> <span class="p">)</span> <span class="n">string</span><span class="p">[</span><span class="mi">0</span><span class="p">]</span> <span class="o">=</span> <span class="sc">&#39;\0&#39;</span><span class="p">;</span></div><div class='line' id='LC248'>&nbsp;&nbsp;<span class="p">}</span></div><div class='line' id='LC249'><span class="p">}</span></div><div class='line' id='LC250'><br/></div><div class='line' id='LC251'><span class="kt">uint8_t</span> <span class="n">CmdMessenger</span><span class="o">::</span><span class="n">checkString</span><span class="p">(</span><span class="kt">char</span> <span class="o">*</span><span class="n">string</span><span class="p">)</span></div><div class='line' id='LC252'><span class="p">{</span></div><div class='line' id='LC253'>&nbsp;&nbsp;<span class="k">if</span> <span class="p">(</span><span class="n">next</span><span class="p">())</span></div><div class='line' id='LC254'>&nbsp;&nbsp;<span class="p">{</span></div><div class='line' id='LC255'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="p">(</span> <span class="n">strcmp</span><span class="p">(</span><span class="n">string</span><span class="p">,</span><span class="n">current</span><span class="p">)</span> <span class="o">==</span> <span class="mi">0</span> <span class="p">)</span></div><div class='line' id='LC256'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">{</span></div><div class='line' id='LC257'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="n">dumped</span> <span class="o">=</span> <span class="mi">1</span><span class="p">;</span></div><div class='line' id='LC258'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">return</span> <span class="mi">1</span><span class="p">;</span></div><div class='line' id='LC259'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">}</span></div><div class='line' id='LC260'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">else</span></div><div class='line' id='LC261'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">{</span></div><div class='line' id='LC262'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">return</span> <span class="mi">0</span><span class="p">;</span></div><div class='line' id='LC263'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="p">}</span></div><div class='line' id='LC264'>&nbsp;&nbsp;<span class="p">}</span> </div><div class='line' id='LC265'><span class="p">}</span></div></pre></div>
          </td>
        </tr>
      </table>
  </div>

          </div>
        </div>

        <a href="#jump-to-line" rel="facebox" data-hotkey="l" class="js-jump-to-line" style="display:none">Jump to Line</a>
        <div id="jump-to-line" style="display:none">
          <h2>Jump to Line</h2>
          <form accept-charset="UTF-8" class="js-jump-to-line-form">
            <input class="textfield js-jump-to-line-field" type="text">
            <div class="full-button">
              <button type="submit" class="button">Go</button>
            </div>
          </form>
        </div>

      </div>
    </div>
</div>

<div id="js-frame-loading-template" class="frame frame-loading large-loading-area" style="display:none;">
  <img class="js-frame-loading-spinner" src="https://a248.e.akamai.net/assets.github.com/images/spinners/octocat-spinner-128.gif?1359500886" height="64" width="64">
</div>


        </div>
      </div>
      <div class="context-overlay"></div>
    </div>

      <div id="footer-push"></div><!-- hack for sticky footer -->
    </div><!-- end of wrapper - hack for sticky footer -->

      <!-- footer -->
      <div id="footer">
  <div class="container clearfix">

      <dl class="footer_nav">
        <dt>GitHub</dt>
        <dd><a href="https://github.com/about">About us</a></dd>
        <dd><a href="https://github.com/blog">Blog</a></dd>
        <dd><a href="https://github.com/contact">Contact &amp; support</a></dd>
        <dd><a href="http://enterprise.github.com/">GitHub Enterprise</a></dd>
        <dd><a href="http://status.github.com/">Site status</a></dd>
      </dl>

      <dl class="footer_nav">
        <dt>Applications</dt>
        <dd><a href="http://mac.github.com/">GitHub for Mac</a></dd>
        <dd><a href="http://windows.github.com/">GitHub for Windows</a></dd>
        <dd><a href="http://eclipse.github.com/">GitHub for Eclipse</a></dd>
        <dd><a href="http://mobile.github.com/">GitHub mobile apps</a></dd>
      </dl>

      <dl class="footer_nav">
        <dt>Services</dt>
        <dd><a href="http://get.gaug.es/">Gauges: Web analytics</a></dd>
        <dd><a href="http://speakerdeck.com">Speaker Deck: Presentations</a></dd>
        <dd><a href="https://gist.github.com">Gist: Code snippets</a></dd>
        <dd><a href="http://jobs.github.com/">Job board</a></dd>
      </dl>

      <dl class="footer_nav">
        <dt>Documentation</dt>
        <dd><a href="http://help.github.com/">GitHub Help</a></dd>
        <dd><a href="http://developer.github.com/">Developer API</a></dd>
        <dd><a href="http://github.github.com/github-flavored-markdown/">GitHub Flavored Markdown</a></dd>
        <dd><a href="http://pages.github.com/">GitHub Pages</a></dd>
      </dl>

      <dl class="footer_nav">
        <dt>More</dt>
        <dd><a href="http://training.github.com/">Training</a></dd>
        <dd><a href="https://github.com/edu">Students &amp; teachers</a></dd>
        <dd><a href="http://shop.github.com">The Shop</a></dd>
        <dd><a href="/plans">Plans &amp; pricing</a></dd>
        <dd><a href="http://octodex.github.com/">The Octodex</a></dd>
      </dl>

      <hr class="footer-divider">


    <p class="right">&copy; 2013 <span title="0.05836s from fe19.rs.github.com">GitHub</span>, Inc. All rights reserved.</p>
    <a class="left" href="https://github.com/">
      <span class="mega-icon mega-icon-invertocat"></span>
    </a>
    <ul id="legal">
        <li><a href="https://github.com/site/terms">Terms of Service</a></li>
        <li><a href="https://github.com/site/privacy">Privacy</a></li>
        <li><a href="https://github.com/security">Security</a></li>
    </ul>

  </div><!-- /.container -->

</div><!-- /.#footer -->


    <div class="fullscreen-overlay js-fullscreen-overlay" id="fullscreen_overlay">
  <div class="fullscreen-container js-fullscreen-container">
    <div class="textarea-wrap">
      <textarea name="fullscreen-contents" id="fullscreen-contents" class="js-fullscreen-contents" placeholder="" data-suggester="fullscreen_suggester"></textarea>
          <div class="suggester-container">
              <div class="suggester fullscreen-suggester js-navigation-container" id="fullscreen_suggester"
                 data-url="/dreamcat4/CmdMessenger/suggestions/commit">
              </div>
          </div>
    </div>
  </div>
  <div class="fullscreen-sidebar">
    <a href="#" class="exit-fullscreen js-exit-fullscreen tooltipped leftwards" title="Exit Zen Mode">
      <span class="mega-icon mega-icon-normalscreen"></span>
    </a>
    <a href="#" class="theme-switcher js-theme-switcher tooltipped leftwards"
      title="Switch themes">
      <span class="mini-icon mini-icon-brightness"></span>
    </a>
  </div>
</div>



    <div id="ajax-error-message" class="flash flash-error">
      <span class="mini-icon mini-icon-exclamation"></span>
      Something went wrong with that request. Please try again.
      <a href="#" class="mini-icon mini-icon-remove-close ajax-error-dismiss"></a>
    </div>

    
    
    <span id='server_response_time' data-time='0.05878' data-host='fe19'></span>
    
  </body>
</html>

