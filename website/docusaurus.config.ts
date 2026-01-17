import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@docusaurus/types';
import type * as Preset from '@docusaurus/preset-classic';

const config: Config = {
  title: 'Make Me A Sammich', // Updated title
  tagline: 'Delicious Recipes',
  favicon: 'img/favicon.ico',

  future: {
    v4: true,
  },

  url: 'http://GEEK:3000',
  baseUrl: '/',

  organizationName: 'millerjohneric',
  projectName: 'MakeMeASammich',

  // CHANGED: Changed to 'warn' so the site doesn't crash on broken images
  onBrokenLinks: 'warn',
  markdown: {
      format: 'mdx',
      hooks: {
        onBrokenMarkdownLinks: 'warn',
      },
    },

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  // ADDED: Redirects plugin to send "/" to "/docs/category/foodmenu"
  plugins: [
    [
      '@docusaurus/plugin-client-redirects',
      {
        redirects: [
          {
            from: '/',
            to: '/docs/foodmenu',
          },
        ],
      },
    ],
  ],

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          // CHANGED: Setting routeBasePath to 'docs' (default)
          // If you wanted the docs to be the ENTIRE site, you'd use '/' here
        },
        blog: false, // Set to false if you aren't using the blog
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    image: 'img/docusaurus-social-card.jpg',
    colorMode: {
      respectPrefersColorScheme: true,
    },
    navbar: {
      title: 'Sammich Recipes',
      logo: {
        alt: 'Site Logo',
        src: 'img/logo.svg',
      },
      items: [
        {
          // CHANGE THIS: Instead of type: 'docSidebar'
          to: '/docs',
          label: 'Food Menu',
          position: 'left',
        },
        {
          href: 'https://github.com/millerjohneric/MakeMeASammich',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            {
              label: 'Food Menu',
              to: '/docs',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} Make Me A Sammich. Built with Docusaurus.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,
};

export default config;