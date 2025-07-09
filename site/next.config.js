/** @type {import('next').NextConfig} */

const nextConfig = {
  output: 'export',
  distDir: 'out',
  env: {
    name: 'JonDevs Workspaces',
    description: 'JonDevs store for Kasm supported workspaces.',
    icon: 'https://JongoDB.github.io/kasm-jondevs/1.1/image.png',
    listUrl: 'https://JongoDB.github.io/kasm-jondevs/',
    contactUrl: 'https://kasmweb.com/support',
  },
  reactStrictMode: true,
  basePath: '/kasm-jondevs/1.1',
  trailingSlash: true,
  images: {
    unoptimized: true,
  }
}

module.exports = nextConfig
