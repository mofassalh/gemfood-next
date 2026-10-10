'use client'

import { useEffect, useState } from 'react'
import Link from 'next/link'
import Image from 'next/image'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase'
import CartCount from '@/components/CartCount'
import { RESTAURANT_ID } from '@/lib/restaurant'

interface NavbarProps {
  selectedLocation: string | null
  onLocationClick: () => void
}

// The location props are kept so existing pages still compile; the dropdown was replaced by page links (single location)
export default function Navbar(_props: NavbarProps) {
  const [settings, setSettings] = useState<any>({})
  const [user, setUser] = useState<any>(null)
  const [dropdownOpen, setDropdownOpen] = useState(false)
  const router = useRouter()

  useEffect(() => {
    const supabase = createClient()
    supabase.from('settings').select('key, value').eq('restaurant_id', RESTAURANT_ID).then(({ data }) => {
      const map: any = {}
      data?.forEach((r: any) => { map[r.key] = r.value })
      setSettings(map)
    })
    supabase.auth.getUser().then(({ data }) => {
      setUser(data.user)
    })
    const { data: listener } = supabase.auth.onAuthStateChange((_event, session) => {
      setUser(session?.user ?? null)
    })
    return () => listener.subscription.unsubscribe()
  }, [])

  const handleSignOut = async () => {
    const supabase = createClient()
    await supabase.auth.signOut()
    setUser(null)
    setDropdownOpen(false)
    router.push('/')
  }

  const getInitial = () => {
    if (user?.user_metadata?.full_name) return user.user_metadata.full_name[0].toUpperCase()
    if (user?.email) return user.email[0].toUpperCase()
    return '?'
  }

  const restaurantName = settings.business_name || "Gem Food"
  const logoUrl = settings.logo_url || ''

  return (
    <nav className="fixed top-0 left-0 right-0 z-50 bg-white border-b border-gray-100 shadow-sm">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          <Link href="/" className="flex items-center gap-2">
            {logoUrl
              ? <img src={logoUrl} alt={restaurantName} className="w-[52px] h-[52px] rounded-full object-cover" />
              : <Image src="/logo.jpg" alt={restaurantName} width={52} height={52} className="rounded-full object-cover" />
            }
            <span className="font-bold text-lg sm:text-2xl whitespace-nowrap truncate max-w-[150px] sm:max-w-none" style={{fontFamily: 'var(--font-sans)'}}>{restaurantName}</span>
          </Link>
          <div className="hidden sm:flex items-center gap-8 text-sm font-semibold text-gray-700">
            <Link href="/menu" className="hover:text-orange-600 transition-colors">Menu</Link>
            <Link href="/about" className="hover:text-orange-600 transition-colors">About</Link>
            <Link href="/faq" className="hover:text-orange-600 transition-colors">FAQ</Link>
          </div>
          <div className="flex items-center gap-3">
            <Link href="/cart" className="relative p-2 rounded-full hover:bg-gray-100 transition-colors">
              <svg className="w-5 h-5 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z" />
              </svg>
              <CartCount />
            </Link>
            {user ? (
              <div className="relative">
                <button onClick={() => setDropdownOpen(!dropdownOpen)} className="w-9 h-9 rounded-full flex items-center justify-center font-bold text-sm overflow-hidden" style={{background: 'var(--color-primary)', color: '#FFFFFF'}}>
                  {user.user_metadata?.avatar_url ? (
                    <img src={user.user_metadata.avatar_url} className="w-9 h-9 rounded-full object-cover" alt="avatar" />
                  ) : getInitial()}
                </button>
                {dropdownOpen && (
                  <div className="absolute right-0 top-11 bg-white rounded-2xl shadow-xl border border-gray-100 w-48 py-2 z-50">
                    <div className="px-4 py-2 border-b border-gray-100">
                      <div className="text-xs text-gray-400">Signed in as</div>
                      <div className="text-sm font-semibold text-gray-800 truncate">{user.email}</div>
                    </div>
                    <Link href="/account" className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-50" onClick={() => setDropdownOpen(false)}>My Account</Link>
                    <button onClick={handleSignOut} className="w-full text-left px-4 py-2 text-sm text-red-500 hover:bg-red-50">Sign Out</button>
                  </div>
                )}
              </div>
            ) : (
              <Link href="/login" className="text-sm font-semibold px-4 py-2 rounded-full transition-all hover:opacity-90" style={{background: 'var(--color-primary)', color: '#FFFFFF'}}>Sign In</Link>
            )}
          </div>
        </div>
      </div>
    </nav>
  )
}
