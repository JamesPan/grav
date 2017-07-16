---
title: Pastime
jscomments:
    title: Pastime
    url: 'http://blog.jamespan.me/pastime/'
    id: /favorite/index.html
comments: true
routes:
    aliases:
        - /pastime
        - /favorite
---

也许你听说过，「业余时间决定人生」；也许你还听说过，「听过很多道理，依然过不好这一生」。书籍、代码、博客、运动、电影、动漫、美剧、游戏，这就是我的业余生活。

> 我的能力就这么多。我若全心工作，则必然忽略生活；我若用心生活，则必然一事无成；我若两者兼顾，又难免平庸

趁我在还能写得动代码看得进书的年纪，努力一回，看看这平庸的资质究竟能发挥几分。

===

{{% twig %}}
{% spaceless %}
{% import "macros/macros.html.twig" as macros %}
{% set items = {} %}
{% if config.flows is defined %}
  {% set items = items | merge(config.flows.pastime) %}
{% endif %}
{% if config.flows_archive is defined %}
  {% set items = items | merge(config.flows_archive.pastime) %}
{% endif %}
{% endspaceless %}
{{ macros.image_flow(items) }}
{{% end %}}

<p id="btn-more" align="center"><a class="button" href="javascript:;">Show More</a></p>

<script type="text/javascript">
$(function() {
  if (window.location.hash) {
    do {
      var mapping = {
        'book': ['book.douban.com', 'www.oreilly.com', 'www.amazon.cn'],
        'movie': ['movie.douban.com'],
      }
      var filter = window.location.hash.substring(1);
      var domains = mapping[filter];
      if (domains == null) {
        break;
      }
      $('figure').each(function(i) {
        var url = $(this).find('a')[0].href;
        var hostname = (new URL(url)).hostname;
        if ($.inArray(hostname, domains) < 0) {
          $(this).remove();
        }
      });
    } while(false);
  }
  var shown = 20;
  $('figure').slice(shown).addClass('foldable');
  if ($('.foldable').length > 0) {
    $('.foldable').hide();
    $('#btn-more').click(function() {
      $('.foldable').show();
      $('#btn-more').hide();
    });
  }  
});
</script>
