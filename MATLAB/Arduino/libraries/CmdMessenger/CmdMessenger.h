  


<!DOCTYPE html>
<html>
  <head prefix="og: http://ogp.me/ns# fb: http://ogp.me/ns/fb# githubog: http://ogp.me/ns/fb/githubog#">
    <meta charset='utf-8'>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>CmdMessenger/CmdMessenger.h at master · dreamcat4/CmdMessenger</title>
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

        <link data-pjax-transient rel='permalink' href='/dreamcat4/CmdMessenger/blob/2aa7caa3beadb2257ec811b04b9e4983f78ee80d/CmdMessenger.h'>
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
                  <a href="/dreamcat4/CmdMessenger/blob/master/CmdMessenger.h" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="master" rel="nofollow" title="master">master</a>
                </div> <!-- /.select-menu-item -->
            </div>

              <div class="select-menu-no-results">Nothing to show</div>
          </div> <!-- /.select-menu-list -->


          <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket css-truncate" data-tab-filter="tags">
            <div data-filterable-for="commitish-filter-field" data-filterable-type="substring">

                <div class="select-menu-item js-navigation-item js-navigation-target ">
                  <span class="select-menu-item-icon mini-icon mini-icon-confirm"></span>
                  <a href="/dreamcat4/CmdMessenger/blob/v2.20/CmdMessenger.h" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="v2.20" rel="nofollow" title="v2.20">v2.20</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item js-navigation-target ">
                  <span class="select-menu-item-icon mini-icon mini-icon-confirm"></span>
                  <a href="/dreamcat4/CmdMessenger/blob/v2.10/CmdMessenger.h" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="v2.10" rel="nofollow" title="v2.10">v2.10</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item js-navigation-target ">
                  <span class="select-menu-item-icon mini-icon mini-icon-confirm"></span>
                  <a href="/dreamcat4/CmdMessenger/blob/v2.05/CmdMessenger.h" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="v2.05" rel="nofollow" title="v2.05">v2.05</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item js-navigation-target ">
                  <span class="select-menu-item-icon mini-icon mini-icon-confirm"></span>
                  <a href="/dreamcat4/CmdMessenger/blob/v2.00/CmdMessenger.h" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="v2.00" rel="nofollow" title="v2.00">v2.00</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item js-navigation-target ">
                  <span class="select-menu-item-icon mini-icon mini-icon-confirm"></span>
                  <a href="/dreamcat4/CmdMessenger/blob/v0.10/CmdMessenger.h" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="v0.10" rel="nofollow" title="v0.10">v0.10</a>
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
          


<!-- blob contrib key: blob_contributors:v21:1ef2d740ae6e608ff67df442b4a2bba3 -->
<!-- blob contrib frag key: views10/v8/blob_contributors:v21:1ef2d740ae6e608ff67df442b4a2bba3 -->


<div id="slider">
    <div class="frame-meta">

      <p title="This is a placeholder element" class="js-history-link-replace hidden"></p>

        <div class="breadcrumb">
          <span class='bold'><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/dreamcat4/CmdMessenger" class="js-slide-to" data-branch="master" data-direction="back" itemscope="url"><span itemprop="title">CmdMessenger</span></a></span></span><span class="separator"> / </span><strong class="final-path">CmdMessenger.h</strong> <span class="js-zeroclipboard zeroclipboard-button" data-clipboard-text="CmdMessenger.h" data-copied-hint="copied!" title="copy to clipboard"><span class="mini-icon mini-icon-clipboard"></span></span>
        </div>

      <a href="/dreamcat4/CmdMessenger/find/master" class="js-slide-to" data-hotkey="t" style="display:none">Show File Finder</a>


        
  <div class="commit file-history-tease">
    <img class="main-avatar" height="24" src="https://secure.gravatar.com/avatar/be09cd7fed65f1ee5340c33607a5ee9a?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="24" />
    <span class="author"><a href="/lemio" rel="author">lemio</a></span>
    <time class="js-relative-date" datetime="2012-01-02T10:29:07-08:00" title="2012-01-02 10:29:07">January 02, 2012</time>
    <div class="commit-title">
        <a href="/dreamcat4/CmdMessenger/commit/d89e8c2f9bbe40c32a6039abae43688c361325ca" class="message">Making cmdMessage available for Arduino 1.0 and higher...</a>
    </div>

    <div class="participation">
      <p class="quickstat"><a href="#blob_contributors_box" rel="facebox"><strong>2</strong> contributors</a></p>
          <a class="avatar tooltipped downwards" title="dreamcat4" href="/dreamcat4/CmdMessenger/commits/master/CmdMessenger.h?author=dreamcat4"><img height="20" src="https://secure.gravatar.com/avatar/373aea769d4accb42aeb1cffaa935774?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="20" /></a>
    <a class="avatar tooltipped downwards" title="lemio" href="/dreamcat4/CmdMessenger/commits/master/CmdMessenger.h?author=lemio"><img height="20" src="https://secure.gravatar.com/avatar/be09cd7fed65f1ee5340c33607a5ee9a?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="20" /></a>


    </div>
    <div id="blob_contributors_box" style="display:none">
      <h2>Users on GitHub who have contributed to this file</h2>
      <ul class="facebox-user-list">
        <li>
          <img height="24" src="https://secure.gravatar.com/avatar/373aea769d4accb42aeb1cffaa935774?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="24" />
          <a href="/dreamcat4">dreamcat4</a>
        </li>
        <li>
          <img height="24" src="https://secure.gravatar.com/avatar/be09cd7fed65f1ee5340c33607a5ee9a?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="24" />
          <a href="/lemio">lemio</a>
        </li>
      </ul>
    </div>
  </div>


    </div><!-- ./.frame-meta -->

    <div class="frames">
      <div class="frame" data-permalink-url="/dreamcat4/CmdMessenger/blob/2aa7caa3beadb2257ec811b04b9e4983f78ee80d/CmdMessenger.h" data-title="CmdMessenger/CmdMessenger.h at master · dreamcat4/CmdMessenger · GitHub" data-type="blob">

        <div id="files" class="bubble">
          <div class="file">
            <div class="meta">
              <div class="info">
                <span class="icon"><b class="mini-icon mini-icon-text-file"></b></span>
                <span class="mode" title="File Mode">file</span>
                  <span>93 lines (71 sloc)</span>
                <span>2.841 kb</span>
              </div>
              <div class="actions">
                <div class="button-group">
                        <a class="minibutton tooltipped leftwards"
                           title="Clicking this button will automatically fork this project so you can edit the file"
                           href="/dreamcat4/CmdMessenger/edit/master/CmdMessenger.h"
                           data-method="post" rel="nofollow">Edit</a>
                  <a href="/dreamcat4/CmdMessenger/raw/master/CmdMessenger.h" class="button minibutton " id="raw-url">Raw</a>
                    <a href="/dreamcat4/CmdMessenger/blame/master/CmdMessenger.h" class="button minibutton ">Blame</a>
                  <a href="/dreamcat4/CmdMessenger/commits/master/CmdMessenger.h" class="button minibutton " rel="nofollow">History</a>
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
</pre>
          </td>
          <td width="100%">
                  <div class="highlight"><pre><div class='line' id='LC1'><span class="cp">#ifndef CmdMessenger_h</span></div><div class='line' id='LC2'><span class="cp">#define CmdMessenger_h</span></div><div class='line' id='LC3'><br/></div><div class='line' id='LC4'><span class="cp">#include &lt;inttypes.h&gt;</span></div><div class='line' id='LC5'><span class="cp">#if defined(ARDUINO) &amp;&amp; ARDUINO &gt;= 100</span></div><div class='line' id='LC6'><span class="cp">#include &quot;Arduino.h&quot;</span></div><div class='line' id='LC7'><span class="cp">#else</span></div><div class='line' id='LC8'><span class="cp">#include &quot;WProgram.h&quot;</span></div><div class='line' id='LC9'><span class="cp">#endif</span></div><div class='line' id='LC10'><br/></div><div class='line' id='LC11'><br/></div><div class='line' id='LC12'><span class="cp">#include &quot;Stream.h&quot;</span></div><div class='line' id='LC13'><br/></div><div class='line' id='LC14'><span class="k">extern</span> <span class="s">&quot;C&quot;</span> <span class="p">{</span></div><div class='line' id='LC15'>&nbsp;&nbsp;<span class="c1">// Our callbacks are always method signature: void cmd(void);</span></div><div class='line' id='LC16'>&nbsp;&nbsp;<span class="k">typedef</span> <span class="kt">void</span> <span class="p">(</span><span class="o">*</span><span class="n">messengerCallbackFunction</span><span class="p">)(</span><span class="kt">void</span><span class="p">);</span></div><div class='line' id='LC17'><span class="p">}</span></div><div class='line' id='LC18'><br/></div><div class='line' id='LC19'><span class="cp">#define MAXCALLBACKS 50        </span><span class="c1">// The maximum number of unique commands</span></div><div class='line' id='LC20'><span class="cp">#define MESSENGERBUFFERSIZE 64 </span><span class="c1">// The maximum length of the buffer (defaults to 64)</span></div><div class='line' id='LC21'><span class="cp">#define DEFAULT_TIMEOUT 5000   </span><span class="c1">// Abandon incomplete messages if nothing heard after 5 seconds</span></div><div class='line' id='LC22'><br/></div><div class='line' id='LC23'><span class="n">class</span> <span class="n">CmdMessenger</span></div><div class='line' id='LC24'><span class="p">{</span>  </div><div class='line' id='LC25'><br/></div><div class='line' id='LC26'><span class="nl">protected:</span></div><div class='line' id='LC27'>&nbsp;&nbsp;<span class="kt">uint8_t</span> <span class="n">bufferIndex</span><span class="p">;</span>     <span class="c1">// Index where to write the data</span></div><div class='line' id='LC28'>&nbsp;&nbsp;<span class="kt">uint8_t</span> <span class="n">bufferLength</span><span class="p">;</span>    <span class="c1">// Is set to MESSENGERBUFFERSIZE</span></div><div class='line' id='LC29'>&nbsp;&nbsp;<span class="kt">uint8_t</span> <span class="n">bufferLastIndex</span><span class="p">;</span> <span class="c1">// The last index of the buffer</span></div><div class='line' id='LC30'><br/></div><div class='line' id='LC31'>&nbsp;&nbsp;<span class="n">messengerCallbackFunction</span> <span class="n">default_callback</span><span class="p">;</span></div><div class='line' id='LC32'>&nbsp;&nbsp;<span class="n">messengerCallbackFunction</span> <span class="n">callbackList</span><span class="p">[</span><span class="n">MAXCALLBACKS</span><span class="p">];</span></div><div class='line' id='LC33'><br/></div><div class='line' id='LC34'>&nbsp;&nbsp;<span class="c1">// (not implemented, generally not needed)</span></div><div class='line' id='LC35'>&nbsp;&nbsp;<span class="c1">// when we are sending a message and requre answer or acknowledgement</span></div><div class='line' id='LC36'>&nbsp;&nbsp;<span class="c1">// suspend any processing (process()) when serial intterupt is recieved</span></div><div class='line' id='LC37'>&nbsp;&nbsp;<span class="c1">// Even though we usually only have single processing thread we still need</span></div><div class='line' id='LC38'>&nbsp;&nbsp;<span class="c1">// this i think because Serial interrupts.</span></div><div class='line' id='LC39'>&nbsp;&nbsp;<span class="c1">// Could also be usefull when we want data larger than MESSENGERBUFFERSIZE</span></div><div class='line' id='LC40'>&nbsp;&nbsp;<span class="c1">// we could send a startCmd, which could pauseProcessing and read directly</span></div><div class='line' id='LC41'>&nbsp;&nbsp;<span class="c1">// from serial all the data, send acknowledge etc and then resume processing  </span></div><div class='line' id='LC42'>&nbsp;&nbsp;<span class="n">boolean</span> <span class="n">pauseProcessing</span><span class="p">;</span></div><div class='line' id='LC43'>&nbsp;&nbsp;&nbsp;&nbsp;</div><div class='line' id='LC44'>&nbsp;&nbsp;<span class="kt">void</span> <span class="nf">handleMessage</span><span class="p">();</span> </div><div class='line' id='LC45'>&nbsp;&nbsp;<span class="kt">void</span> <span class="nf">init</span><span class="p">(</span><span class="n">Stream</span> <span class="o">&amp;</span><span class="n">comms</span><span class="p">,</span> <span class="kt">char</span> <span class="n">field_separator</span><span class="p">,</span> <span class="kt">char</span> <span class="n">command_separator</span><span class="p">);</span></div><div class='line' id='LC46'>&nbsp;&nbsp;<span class="kt">uint8_t</span> <span class="nf">process</span><span class="p">(</span><span class="kt">int</span> <span class="n">serialByte</span><span class="p">);</span></div><div class='line' id='LC47'>&nbsp;&nbsp;<span class="kt">void</span> <span class="nf">reset</span><span class="p">();</span></div><div class='line' id='LC48'><br/></div><div class='line' id='LC49'>&nbsp;&nbsp;<span class="kt">char</span> <span class="n">buffer</span><span class="p">[</span><span class="n">MESSENGERBUFFERSIZE</span><span class="p">];</span> <span class="c1">// Buffer that holds the data</span></div><div class='line' id='LC50'>&nbsp;&nbsp;<span class="kt">uint8_t</span> <span class="n">messageState</span><span class="p">;</span></div><div class='line' id='LC51'>&nbsp;&nbsp;<span class="kt">uint8_t</span> <span class="n">dumped</span><span class="p">;</span></div><div class='line' id='LC52'>&nbsp;&nbsp;<span class="kt">char</span><span class="o">*</span> <span class="n">current</span><span class="p">;</span> <span class="c1">// Pointer to current data</span></div><div class='line' id='LC53'>&nbsp;&nbsp;<span class="kt">char</span><span class="o">*</span> <span class="n">last</span><span class="p">;</span></div><div class='line' id='LC54'><br/></div><div class='line' id='LC55'><span class="nl">public:</span></div><div class='line' id='LC56'>&nbsp;&nbsp;<span class="n">CmdMessenger</span><span class="p">(</span><span class="n">Stream</span> <span class="o">&amp;</span><span class="n">comms</span><span class="p">);</span></div><div class='line' id='LC57'>&nbsp;&nbsp;<span class="n">CmdMessenger</span><span class="p">(</span><span class="n">Stream</span> <span class="o">&amp;</span><span class="n">comms</span><span class="p">,</span> <span class="kt">char</span> <span class="n">fld_separator</span><span class="p">);</span></div><div class='line' id='LC58'>&nbsp;&nbsp;<span class="n">CmdMessenger</span><span class="p">(</span><span class="n">Stream</span> <span class="o">&amp;</span><span class="n">comms</span><span class="p">,</span> <span class="kt">char</span> <span class="n">fld_separator</span><span class="p">,</span> <span class="kt">char</span> <span class="n">cmd_separator</span><span class="p">);</span></div><div class='line' id='LC59'><br/></div><div class='line' id='LC60'>&nbsp;&nbsp;<span class="kt">void</span> <span class="nf">attach</span><span class="p">(</span><span class="n">messengerCallbackFunction</span> <span class="n">newFunction</span><span class="p">);</span></div><div class='line' id='LC61'>&nbsp;&nbsp;<span class="kt">void</span> <span class="nf">discard_LF_CR</span><span class="p">();</span></div><div class='line' id='LC62'>&nbsp;&nbsp;<span class="kt">void</span> <span class="nf">print_LF_CR</span><span class="p">();</span></div><div class='line' id='LC63'><br/></div><div class='line' id='LC64'>&nbsp;&nbsp;<span class="kt">uint8_t</span> <span class="nf">next</span><span class="p">();</span></div><div class='line' id='LC65'>&nbsp;&nbsp;<span class="kt">uint8_t</span> <span class="nf">available</span><span class="p">();</span></div><div class='line' id='LC66'><br/></div><div class='line' id='LC67'>&nbsp;&nbsp;<span class="kt">int</span> <span class="nf">readInt</span><span class="p">();</span></div><div class='line' id='LC68'>&nbsp;&nbsp;<span class="kt">char</span> <span class="nf">readChar</span><span class="p">();</span></div><div class='line' id='LC69'>&nbsp;&nbsp;<span class="kt">void</span> <span class="nf">copyString</span><span class="p">(</span><span class="kt">char</span> <span class="o">*</span><span class="n">string</span><span class="p">,</span> <span class="kt">uint8_t</span> <span class="n">size</span><span class="p">);</span></div><div class='line' id='LC70'>&nbsp;&nbsp;<span class="kt">uint8_t</span> <span class="nf">checkString</span><span class="p">(</span><span class="kt">char</span> <span class="o">*</span><span class="n">string</span><span class="p">);</span></div><div class='line' id='LC71'><br/></div><div class='line' id='LC72'>&nbsp;&nbsp;<span class="c1">// Polymorphism used to interact with serial class</span></div><div class='line' id='LC73'>&nbsp;&nbsp;<span class="c1">// Stream is an abstract base class which defines a base set</span></div><div class='line' id='LC74'>&nbsp;&nbsp;<span class="c1">// of functionality used by the serial classes.</span></div><div class='line' id='LC75'>&nbsp;&nbsp;<span class="n">Stream</span> <span class="o">*</span><span class="n">comms</span><span class="p">;</span></div><div class='line' id='LC76'>&nbsp;&nbsp;</div><div class='line' id='LC77'>&nbsp;&nbsp;<span class="kt">void</span> <span class="nf">attach</span><span class="p">(</span><span class="n">byte</span> <span class="n">msgId</span><span class="p">,</span> <span class="n">messengerCallbackFunction</span> <span class="n">newFunction</span><span class="p">);</span></div><div class='line' id='LC78'>&nbsp;&nbsp;</div><div class='line' id='LC79'>&nbsp;&nbsp;<span class="kt">char</span><span class="o">*</span> <span class="nf">sendCmd</span><span class="p">(</span><span class="kt">int</span> <span class="n">cmdId</span><span class="p">,</span> <span class="kt">char</span> <span class="o">*</span><span class="n">msg</span><span class="p">,</span> <span class="n">boolean</span> <span class="n">reqAc</span> <span class="o">=</span> <span class="nb">false</span><span class="p">,</span> </div><div class='line' id='LC80'>		    <span class="kt">char</span> <span class="o">*</span><span class="n">replyBuff</span> <span class="o">=</span> <span class="nb">NULL</span><span class="p">,</span> <span class="kt">int</span> <span class="n">butSize</span> <span class="o">=</span> <span class="mi">0</span><span class="p">,</span> <span class="kt">int</span> <span class="n">timeout</span> <span class="o">=</span> <span class="n">DEFAULT_TIMEOUT</span><span class="p">,</span> </div><div class='line' id='LC81'>		    <span class="kt">int</span> <span class="n">retryCount</span> <span class="o">=</span> <span class="mi">10</span><span class="p">);</span></div><div class='line' id='LC82'><br/></div><div class='line' id='LC83'>&nbsp;&nbsp;<span class="kt">void</span> <span class="nf">feedinSerialData</span><span class="p">();</span></div><div class='line' id='LC84'>&nbsp;&nbsp;</div><div class='line' id='LC85'>&nbsp;&nbsp;<span class="kt">char</span> <span class="n">command_separator</span><span class="p">;</span></div><div class='line' id='LC86'>&nbsp;&nbsp;<span class="kt">char</span> <span class="n">field_separator</span><span class="p">;</span></div><div class='line' id='LC87'><br/></div><div class='line' id='LC88'>&nbsp;&nbsp;<span class="n">boolean</span> <span class="n">discard_newlines</span><span class="p">;</span></div><div class='line' id='LC89'>&nbsp;&nbsp;<span class="n">boolean</span> <span class="n">print_newlines</span><span class="p">;</span></div><div class='line' id='LC90'><br/></div><div class='line' id='LC91'>&nbsp;&nbsp;<span class="n">boolean</span> <span class="nf">blockedTillReply</span><span class="p">(</span><span class="kt">int</span> <span class="n">timeout</span> <span class="o">=</span> <span class="n">DEFAULT_TIMEOUT</span><span class="p">);</span></div><div class='line' id='LC92'><span class="p">};</span></div><div class='line' id='LC93'><span class="cp">#endif</span></div></pre></div>
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


    <p class="right">&copy; 2013 <span title="0.05458s from fe19.rs.github.com">GitHub</span>, Inc. All rights reserved.</p>
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

    
    
    <span id='server_response_time' data-time='0.05506' data-host='fe19'></span>
    
  </body>
</html>

