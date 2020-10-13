<body>
<nav class="navbar navbar-light bg-light">
    <a href="{$urlBase}/index{$urlPostFix}"><img class="logo" src="./img/sqstorage.png" alt="sqStorage logo" /></a>
    <ul class="nav">
        {$pages = ['index.php' => '', 'inventory.php' => '', 'categories.php' => '', 'transfer.php' => '', 'datafields.php' => '', 'settings.php' => '']}
        {$pages[$target] = 'activePage'}
        <li class="nav-item"><a href="{$urlBase}/index{$urlPostFix}" class="nav-link {$pages['index.php']}" >{t}Eintragen{/t}</a></li>
        <li class="nav-item"><a href="{$urlBase}/inventory{$urlPostFix}" class="nav-link {$pages['inventory.php']}">{t}Inventar{/t}</a></li>
        <li class="nav-item"><a href="{$urlBase}/categories{$urlPostFix}" class="nav-link {$pages['categories.php']}">{t}Kategorien{/t}</a></li>
        <li class="nav-item"><a href="{$urlBase}/transfer{$urlPostFix}" class="nav-link {$pages['transfer.php']}">{t}Transferieren{/t}</a></li>
        <li class="nav-item"><a href="{$urlBase}/datafields{$urlPostFix}" class="nav-link {$pages['datafields.php']}">{t}Datenfelder{/t}</a></li>
        {if isset($SESSION.user)}
          {if isset($SESSION.user.usergroupid)}
            {if $SESSION.user.usergroupid == 1}
                <li class="nav-item"><a href="{$urlBase}/settings{$urlPostFix}" class="nav-link {$pages['settings.php']}">{t}Einstellungen{/t}</a></li>
            {/if}
          {/if}
        {/if}
    </ul>

    <form class="form-inline searchArea" method="GET" action="{$urlBase}/inventory{$urlPostFix}">
        <input class="form-control mr-sm-2" name="searchValue" type="search" placeholder="{t}Suche{/t}" aria-label="{t}Suche{/t}">
        <button class="btn btn-outline-success my-2 my-sm-0" type="submit">{t}Suchen{/t}</button>
    </form>
    <!--
        {foreach $langsAvailable as $lang}
                <a href="index.php?lang={$lang}" alt="Language {$langsLabels.$lang}"><small>{$langsLabels.$lang}</small></a><br />
        {/foreach}
    -->
    <div class="dropdown">
         <select class="form-control mr-sm-2" name="lang">
            {foreach $langsAvailable as $lang}
            <option value="{$lang}" {if $langCurrent == $lang} selected="selected"{/if}>{$langsLabels.$lang}</option>
            {/foreach}
        </select>
        <script type ="text/javascript">
            let langSelection = document.querySelector('select[name="lang"').addEventListener('change', function (evt) {
                let langValue = evt.target.options[evt.target.selectedIndex].value
                let srcUri = window.location.href.toString().replace(/.lang=.[^\&\/]*/, '')
                if (srcUri.indexOf('?') === -1) window.location.href = srcUri + '?lang=' + langValue
                else window.location.href = srcUri + '&lang=' + langValue
            })
        </script>
    </div>


    <ul class="nav">
    {if isset($SESSION.user)}
        <li class="nav-item"><a href="{$urlBase}/index{$urlPostFix}?logout" class="nav-link"><i class="fas fa-sign-out-alt" title="{t}Abmelden{/t}"></i></a></li>
    {/if}
    </ul>
</nav>
<p id="msgbox"></p>
