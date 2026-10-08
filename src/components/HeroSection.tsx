'use client'

import { useEffect, useState } from 'react'
import { Open_Sans } from 'next/font/google'
import { createClient } from '@/lib/supabase'
import { RESTAURANT_ID } from '@/lib/restaurant'

// Hero headline font (only used here; other headings keep the site display font)
const heroFont = Open_Sans({ subsets: ['latin'], weight: ['800'], display: 'swap' })

interface HeroProps {
  onOrderClick: () => void
}

export default function HeroSection({ onOrderClick }: HeroProps) {
  const [settings, setSettings] = useState<any>({})
  const [gallery, setGallery] = useState<any[]>([])
  const [loaded, setLoaded] = useState(false)

  useEffect(() => {
    const CACHE_KEY = `hero_cache_${RESTAURANT_ID}`
    const CACHE_TTL = 5 * 60 * 1000 // 5 minutes

    // Load from cache instantly
    try {
      const cached = localStorage.getItem(CACHE_KEY)
      if (cached) {
        const { data, ts } = JSON.parse(cached)
        if (Date.now() - ts < CACHE_TTL) {
          setSettings(data.settings)
          setGallery(data.gallery)
          setLoaded(true)
        }
      }
    } catch {}

    // Always fetch fresh data in background
    const supabase = createClient()
    Promise.all([
      supabase.from('settings').select('*').eq('restaurant_id', RESTAURANT_ID),
      supabase.from('gallery').select('*').eq('restaurant_id', RESTAURANT_ID).limit(4),
    ]).then(([{ data: settingsData }, { data: galleryData }]) => {
      const map: any = {}
      settingsData?.forEach((r: any) => { map[r.key] = r.value })
      setSettings(map)
      if (galleryData && galleryData.length > 0) setGallery(galleryData)
      setLoaded(true)
      // Save to cache
      try {
        localStorage.setItem(CACHE_KEY, JSON.stringify({
          data: { settings: map, gallery: galleryData || [] },
          ts: Date.now()
        }))
      } catch {}
    })
  }, [])

  const businessName = settings.business_name || 'Gem Food'
  const tagline = settings.tagline || 'Order online for pickup or delivery'
  const badge = settings.hero_badge || ''
  const heroTitle1 = settings.hero_title1 || '100%'
  const heroTitle2 = settings.hero_title2 || 'Halal Food'
  const heroTitle3 = settings.hero_title3 || 'Made Fresh'
  const primaryColor = settings.primary_color || '#F26A1B'
  const heroInfo = settings.hero_info || 'Open daily, 11 AM to 11 PM'
  const menuItemCount = settings.menu_item_count || ''
  const rating = settings.hero_rating || ''
  const reviewCount = settings.hero_review_count || ''
  const heroImage = gallery[0]?.image_url || settings.hero_image1 || '/hero.jpg'

  if (!loaded) return (
    <section className="pt-16 relative overflow-hidden" style={{ background: '#1A1A1A' }}>
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 lg:py-28 w-full">
        <div className="h-12 w-64 mb-3 rounded-lg" style={{ background: '#2A2A2A' }} />
        <div className="h-12 w-80 max-w-full mb-8 rounded-lg" style={{ background: '#2A2A2A' }} />
        <div className="h-5 w-72 max-w-full mb-10 rounded" style={{ background: '#2A2A2A' }} />
        <div className="flex gap-4">
          <div className="h-14 w-36 rounded-full" style={{ background: '#2A2A2A' }} />
          <div className="h-14 w-36 rounded-full" style={{ background: '#2A2A2A' }} />
        </div>
      </div>
    </section>
  )

  return (
    <section className="pt-16 relative overflow-hidden flex items-center min-h-[min(100svh,860px)]" style={{ background: '#1A1A1A' }}>

      {/* Food photo: full background on phones, right side on desktop */}
      <div className="absolute inset-0 lg:left-[40%]">
        <img src={heroImage} alt={`Food from ${businessName}`} className="w-full h-full object-cover" />
      </div>
      <div className="absolute inset-0 lg:hidden" style={{ background: 'rgba(26,26,26,0.85)' }} />
      <div className="absolute inset-0 hidden lg:block"
        style={{ background: 'linear-gradient(90deg, #1A1A1A 0%, #1A1A1A 40%, rgba(26,26,26,0.6) 58%, rgba(26,26,26,0) 82%)' }} />

      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 lg:py-20 w-full relative" style={{ zIndex: 1 }}>
        <div className="max-w-xl">
          {badge && (
            <div className="inline-flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-semibold mb-6"
              style={{ background: primaryColor, color: '#1A1A1A' }}>
              {badge}
            </div>
          )}

          <h1 className={`${heroFont.className} text-4xl sm:text-5xl lg:text-[3.5rem] font-extrabold leading-[1.1] tracking-tight mb-6 text-white`}>
            {heroTitle1}{' '}
            <span className="sm:whitespace-nowrap" style={{ color: primaryColor }}>{heroTitle2}</span>
            <br />
            {heroTitle3}
          </h1>

          <p className="text-lg text-gray-200 mb-8 leading-relaxed max-w-md">
            {tagline}
          </p>

          <div className="flex flex-col sm:flex-row gap-4">
            <button onClick={onOrderClick}
              className="px-8 py-4 rounded-full font-semibold text-base transition-all hover:shadow-lg hover:scale-105 active:scale-95"
              style={{ background: primaryColor, color: '#1A1A1A' }}>
              Order Now
            </button>
            <button onClick={onOrderClick}
              className="px-8 py-4 rounded-full font-semibold text-base border-2 border-white text-white transition-all hover:bg-white/10">
              View Menu
            </button>
          </div>

          <div className="flex flex-wrap gap-x-8 gap-y-3 mt-12 pt-8 border-t border-white/20 text-sm text-gray-200">
            {heroInfo && <div>{heroInfo}</div>}
            {menuItemCount && <div><span className="font-bold text-white">{menuItemCount}</span> menu items</div>}
            {rating && <div><span className="font-bold text-white">{rating}</span> rating{reviewCount ? ` (${reviewCount} reviews)` : ''}</div>}
          </div>
        </div>
      </div>
    </section>
  )
}
