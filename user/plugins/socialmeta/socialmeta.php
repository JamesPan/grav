<?php

namespace Grav\Plugin;

//use Grav\Common\Data\Blueprints;
use Grav\Common\Plugin;
use Grav\Common\Page\Page;
use RocketTheme\Toolbox\Event\Event;

/**
 * Class SocialMetaPlugin
 * @package Grav\Plugin
 */
class SocialMetaPlugin extends Plugin
{
    /**
     * @return array
     */
    public static function getSubscribedEvents()
    {
        return [
            'onPluginsInitialized'  => ['onPluginsInitialized', 0],
        ];
    }

    public function onPluginsInitialized()
    {
        if (true === $this->isAdmin()) {
            $this->active = false;
            return;
        }

        if ($this->config->get('plugins.socialmeta.enabled')) {
            $this->enable([
                'onTwigTemplatePaths'   => ['onTwigTemplatePaths', 0],
            ]);
        }
    }

    public function onTwigTemplatePaths()
    {
        $this->grav['twig']->twig_paths[] = __DIR__ . '/templates';
    }
}
