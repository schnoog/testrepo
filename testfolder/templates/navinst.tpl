<body>
<nav class="navbar navbar-light bg-light">
    <a href="{$urlBase}/index{$urlPostFix}"><img class="logo" src="./img/sqstorage.png" alt="sqStorage logo" /></a>



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



</nav>
<p id="msgbox"></p>
