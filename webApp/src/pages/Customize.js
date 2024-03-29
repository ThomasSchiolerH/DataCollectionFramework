import React, { useState } from 'react';
import axios from 'axios';

const Customize = () => {
    const [username, setUsername] = useState('');
    const [message, setMessage] = useState('');
    const [inputType, setInputType] = useState('');
    const [lowestValue, setLowestValue] = useState('');
    const [highestValue, setHighestValue] = useState('');

    const handleSubmit = async (event) => {
        event.preventDefault();
        const serverURL = process.env.REACT_APP_SERVER_URL;

        try {
            await axios.post(`${serverURL}/api/users/customInput`, {
                username,
                message,
                inputType,
                lowestValue,
                highestValue,
            });
            console.log('User input message updated successfully');
            setUsername('');
            setMessage('');
            setInputType('');
            setLowestValue('');
            setHighestValue('');
        } catch (error) {
            console.error('Error updating user input message:', error);
        }
    };

    return (
        <div style={{ textAlign: 'center', padding: '20px', fontFamily: 'Arial' }}>
            <h1 style={{ color: '#333' }}>Customize User Input</h1>
            <form onSubmit={handleSubmit} style={{ maxWidth: '500px', margin: 'auto', display: 'grid', gap: '15px' }}>
                <label htmlFor="username" style={{ fontWeight: 'bold' }}>Username</label>
                <input
                    type="text"
                    id="username"
                    placeholder="Username"
                    value={username}
                    onChange={(e) => setUsername(e.target.value)}
                    style={{ padding: '10px', borderRadius: '5px', border: '1px solid #ccc' }}
                />
                <label htmlFor="message" style={{ fontWeight: 'bold' }}>Message</label>
                <input
                    type="text"
                    id="message"
                    placeholder="Message"
                    value={message}
                    onChange={(e) => setMessage(e.target.value)}
                    style={{ padding: '10px', borderRadius: '5px', border: '1px solid #ccc' }}
                />
                <label htmlFor="inputType" style={{ fontWeight: 'bold' }}>Input Type</label>
                <input
                    type="text"
                    id="inputType"
                    placeholder="inputType"
                    value={inputType}
                    onChange={(e) => setInputType(e.target.value)}
                    style={{ padding: '10px', borderRadius: '5px', border: '1px solid #ccc' }}
                />
                <label htmlFor="lowestValue" style={{ fontWeight: 'bold' }}>Lowest Value</label>
                <input
                    type="text"
                    id="lowestValue"
                    placeholder="lowestValue"
                    value={lowestValue}
                    onChange={(e) => setLowestValue(e.target.value)}
                    style={{ padding: '10px', borderRadius: '5px', border: '1px solid #ccc' }}
                />
                <label htmlFor="highestValue" style={{ fontWeight: 'bold' }}>Highest Value</label>
                <input
                    type="text"
                    id="highestValue"
                    placeholder="highestValue"
                    value={highestValue}
                    onChange={(e) => setHighestValue(e.target.value)}
                    style={{ padding: '10px', borderRadius: '5px', border: '1px solid #ccc' }}
                />
                <button type="submit" style={{ padding: '10px 20px', borderRadius: '5px', border: 'none', backgroundColor: '#007bff', color: 'white', cursor: 'pointer' }}>
                    Submit
                </button>
            </form>
        </div>
    );
};

export default Customize;
