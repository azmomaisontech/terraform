
export function Page({ title }: { title: string }) {
  return (
    <>
      <h1>
        <span> Hello there, </span>
        Welcome to {title} 👋
      </h1>
    </>
  );
}

export default Page;
