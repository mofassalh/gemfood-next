import type { Metadata } from 'next'
import Script from 'next/script'
import './globals.css'
import { getSettings } from '@/lib/settings'
import CookieBanner from '@/components/CookieBanner'

const GA_ID = 'G-RD2J6J2DMZ'

export async function generateMetadata(): Promise<Metadata> {
  const settings = await getSettings()
  const businessName = settings.business_name || "Gem Food"
  const description = settings.tagline || 'Order 100% halal food online from Gem Food in St. Petersburg, Florida.'

  return {
    title: {
      default: businessName,
      template: `%s | ${businessName}`,
    },
    description,
    keywords: ['halal', 'halal food', 'online order', 'St. Petersburg', 'Florida', 'takeaway', 'pickup'],
    icons: { icon: '/logo.jpg', apple: '/logo.jpg' },
    openGraph: {
      title: businessName,
      description,
      type: 'website',
      url: 'https://gemfoodeat.com',
      siteName: businessName,
    },
    twitter: {
      card: 'summary_large_image',
      title: businessName,
      description,
    },
    robots: {
      index: true,
      follow: true,
    },
  }
}

export default async function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const settings = await getSettings()
  const primaryColor = settings.primary_color || '#F26A1B'
  const businessName = settings.business_name || "Gem Food"

  const structuredData = {
    '@context': 'https://schema.org',
    '@type': 'Restaurant',
    name: businessName,
    url: 'https://gemfoodeat.com',
    telephone: '+1 727-954-0001',
    servesCuisine: ['Halal'],
    hasMenu: 'https://gemfoodeat.com/menu',
    location: [
      { '@type': 'Place', name: 'Gem Food', address: { '@type': 'PostalAddress', streetAddress: '2800 38th Ave N', addressLocality: 'St. Petersburg', addressRegion: 'FL', postalCode: '33713', addressCountry: 'US' } },
    ],
  }

  return (
    <html lang="en">
      <head>
        <style>{`
          :root {
            --color-primary: ${primaryColor};
            --font-display: 'Georgia', serif;
          }
        `}</style>
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(structuredData) }}
        />
      </head>
      <body>
        <Script
          src={`https://www.googletagmanager.com/gtag/js?id=${GA_ID}`}
          strategy="afterInteractive"
        />
        <Script id="google-analytics" strategy="afterInteractive">
          {`
            window.dataLayer = window.dataLayer || [];
            function gtag(){dataLayer.push(arguments);}
            gtag('js', new Date());
            gtag('config', '${GA_ID}');
          `}
        </Script>
        {children}
        <CookieBanner />
      </body>
    </html>
  )
}
