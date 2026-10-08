import { NextResponse } from 'next/server'

// Google reviews for the homepage.
// Needs GOOGLE_PLACES_API_KEY (server only). GOOGLE_PLACE_ID is optional:
// without it the place is looked up by name and address.
// Only 4 and 5 star reviews are returned; the overall rating is Google's real average.

export const revalidate = 43200 // refresh from Google about twice a day

const PLACE_QUERY = 'Gem Food, 2800 38th Ave N, St. Petersburg, FL 33713'
const EMPTY = { rating: null, count: null, mapsUrl: null, reviews: [] }

export async function GET() {
  const key = process.env.GOOGLE_PLACES_API_KEY
  if (!key) return NextResponse.json(EMPTY)

  try {
    let placeId = process.env.GOOGLE_PLACE_ID || ''
    if (!placeId) {
      const search = await fetch('https://places.googleapis.com/v1/places:searchText', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': key,
          'X-Goog-FieldMask': 'places.id',
        },
        body: JSON.stringify({ textQuery: PLACE_QUERY }),
      })
      const found = await search.json()
      placeId = found?.places?.[0]?.id || ''
      if (!placeId) return NextResponse.json(EMPTY)
    }

    const res = await fetch(`https://places.googleapis.com/v1/places/${placeId}`, {
      headers: {
        'X-Goog-Api-Key': key,
        'X-Goog-FieldMask': 'rating,userRatingCount,googleMapsUri,reviews',
      },
    })
    if (!res.ok) return NextResponse.json(EMPTY)
    const place = await res.json()

    const reviews = (place.reviews || [])
      .filter((r: any) => (r.rating || 0) >= 4 && (r.text?.text || r.originalText?.text))
      .map((r: any) => ({
        author: r.authorAttribution?.displayName || 'Google user',
        authorUrl: r.authorAttribution?.uri || null,
        photo: r.authorAttribution?.photoUri || null,
        rating: r.rating,
        text: r.text?.text || r.originalText?.text || '',
        when: r.relativePublishTimeDescription || '',
      }))

    return NextResponse.json(
      {
        rating: place.rating ?? null,
        count: place.userRatingCount ?? null,
        mapsUrl: place.googleMapsUri ?? null,
        reviews,
      },
      { headers: { 'Cache-Control': 'public, s-maxage=43200, stale-while-revalidate=86400' } }
    )
  } catch {
    return NextResponse.json(EMPTY)
  }
}
