export const revalidate = 60;

async function getData() {
  const res = await fetch('https://api.github.com/repos/vercel/next.js', {
    next: {
      revalidate: 60
    }
  });

  if (!res.ok) {
    throw new Error('Failed to fetch data');
  }

  return res.json();
}

export default async function ISRExample() {
  const data = await getData();
  
  return (
    <div className="p-8">
      <h1 className="text-2xl font-bold mb-4">
        ISR Example - GitHub Next.js Stats
      </h1>
      
      <div className="bg-white dark:bg-zinc-800 rounded-lg p-6 shadow-lg">
        <p className="mb-2">
          <span className="font-semibold">Repository:</span> {data.full_name}
        </p>
        <p className="mb-2">
          <span className="font-semibold">Stars:</span> {data.stargazers_count}
        </p>
        <p className="mb-2">
          <span className="font-semibold">Forks:</span> {data.forks_count}
        </p>
        <p className="text-sm text-gray-500 mt-4">
          Last updated: {new Date().toLocaleString()}
        </p>
      </div>
    </div>
  );
} 