import type { NextConfig } from "next";
const nextConfig: NextConfig = {
  images: {
    domains: ['qzwhuyfnuckdhizdwrkm.supabase.co'],
  },
  async redirects() {
    return [
      {
        source: '/admin',
        destination: 'https://gemfood-admin.vercel.app',
        permanent: false,
      },
      {
        source: '/admin/:path*',
        destination: 'https://gemfood-admin.vercel.app/admin/:path*',
        permanent: false,
      },
    ]
  },
};
export default nextConfig;
