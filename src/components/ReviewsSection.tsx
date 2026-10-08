'use client'

import { useEffect, useState } from 'react'

interface Review {
  author: string
  authorUrl: string | null
  photo: string | null
  rating: number
  text: string
  when: string
}

interface ReviewsData {
  rating: number | null
  count: number | null
  mapsUrl: string | null
  reviews: Review[]
}

function Stars({ value }: { value: number }) {
  const full = Math.round(value)
  return (
    <span aria-label={`${value} out of 5 stars`} className="tracking-tight" style={{ color: 'var(--color-primary)' }}>
      {'★'.repeat(full)}
      <span className="text-gray-300">{'★'.repeat(5 - full)}</span>
    </span>
  )
}

// Real reviews from Google. The whole section stays hidden until Google returns something.
export default function ReviewsSection() {
  const [data, setData] = useState<ReviewsData | null>(null)

  useEffect(() => {
    fetch('/api/reviews')
      .then(r => r.json())
      .then(setData)
      .catch(() => {})
  }, [])

  if (!data || data.reviews.length === 0) return null

  return (
    <section className="py-16 sm:py-20 px-4 sm:px-6 lg:px-8" style={{ background: '#FFF7F2' }}>
      <div className="max-w-7xl mx-auto">
        <div className="text-center mb-10">
          <h2 className="text-3xl sm:text-4xl font-bold text-gray-900" style={{ fontFamily: 'var(--font-display)' }}>
            What Our Customers Say
          </h2>
          {data.rating !== null && (
            <p className="mt-3 text-gray-600 flex flex-wrap items-center justify-center gap-x-2 gap-y-1">
              <span className="text-xl font-bold text-gray-900">{data.rating.toFixed(1)}</span>
              <span className="text-xl"><Stars value={data.rating} /></span>
              {data.count !== null && <span>from {data.count} reviews on Google</span>}
            </p>
          )}
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {data.reviews.map((r, i) => (
            <figure key={i} className="bg-white rounded-2xl p-6 border border-orange-100 flex flex-col">
              <div className="text-lg mb-3"><Stars value={r.rating} /></div>
              <blockquote className="text-gray-700 leading-relaxed line-clamp-6 flex-1">{r.text}</blockquote>
              <figcaption className="mt-5 flex items-center gap-3">
                {r.photo ? (
                  <img src={r.photo} alt="" referrerPolicy="no-referrer" className="w-10 h-10 rounded-full object-cover" />
                ) : (
                  <span className="w-10 h-10 rounded-full flex items-center justify-center font-bold text-gray-900" style={{ background: '#FFD9BF' }}>
                    {r.author.charAt(0).toUpperCase()}
                  </span>
                )}
                <span>
                  <span className="block font-semibold text-gray-900">{r.author}</span>
                  <span className="block text-sm text-gray-500">{r.when ? `${r.when} · ` : ''}Google review</span>
                </span>
              </figcaption>
            </figure>
          ))}
        </div>

        {data.mapsUrl && (
          <div className="text-center mt-10">
            <a href={data.mapsUrl} target="_blank" rel="noopener noreferrer"
              className="inline-block px-7 py-3 rounded-full font-semibold border-2 text-gray-900 hover:bg-white transition-colors"
              style={{ borderColor: 'var(--color-primary)' }}>
              Read all reviews on Google
            </a>
          </div>
        )}
      </div>
    </section>
  )
}
