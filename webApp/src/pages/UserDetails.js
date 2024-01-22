import React from 'react';
import { useParams } from 'react-router-dom';

const UserDetails = () => {
  const { userId } = useParams();

  return (
    <div>
      <h1>User Details Page</h1>
      <p>User ID: {userId}</p>
      {/* You can expand this component to show more user details */}
    </div>
  );
};

export default UserDetails;
