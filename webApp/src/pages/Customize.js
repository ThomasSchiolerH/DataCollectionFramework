import React, { useState } from 'react';
import axios from 'axios';

const Customize = () => {
    const [username, setUsername] = useState('');
    const [message, setMessage] = useState('');
    const [inputType, setInputType] = useState('');
    const [lowestValue, setLowestValue] = useState('');
    const [highestValue, setHighestValue] = useState('');
    const [enabledSensors, setEnabledSensors] = useState({
        steps: false,
        heartRate: false,
        exerciseTime: false,
        BMI: false,
    });

    const handleSensorChange = (sensor) => {
        setEnabledSensors(prevSensors => ({
            ...prevSensors,
            [sensor]: !prevSensors[sensor],
        }));
    };

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
                enabledSensors,
            });
            console.log('User input message updated successfully');
            setUsername('');
            setMessage('');
            setInputType('');
            setLowestValue('');
            setHighestValue('');
            setEnabledSensors({
                steps: false,
                heartRate: false,
                exerciseTime: false,
                BMI: false,
            });
        } catch (error) {
            console.error('Error updating user input message:', error);
        }
    };

    return (
        <div style={{ textAlign: 'center', padding: '20px', fontFamily: 'Arial', maxWidth: '700px', margin: '0 auto' }}>
            <h1 style={{ color: '#333' }}>Customize User Input</h1>
            <form onSubmit={handleSubmit} style={{ display: 'grid', gap: '20px' }}>
                <input
                    type="text"
                    id="username"
                    placeholder="Username"
                    value={username}
                    onChange={(e) => setUsername(e.target.value)}
                    style={{ padding: '10px', borderRadius: '5px', border: '1px solid #ccc' }}
                />
                <input
                    type="text"
                    id="message"
                    placeholder="Message"
                    value={message}
                    onChange={(e) => setMessage(e.target.value)}
                    style={{ padding: '10px', borderRadius: '5px', border: '1px solid #ccc' }}
                />
                <input
                    type="text"
                    id="inputType"
                    placeholder="Input Type"
                    value={inputType}
                    onChange={(e) => setInputType(e.target.value)}
                    style={{ padding: '10px', borderRadius: '5px', border: '1px solid #ccc' }}
                />
                <input
                    type="text"
                    id="lowestValue"
                    placeholder="Lowest Value"
                    value={lowestValue}
                    onChange={(e) => setLowestValue(e.target.value)}
                    style={{ padding: '10px', borderRadius: '5px', border: '1px solid #ccc' }}
                />
                <input
                    type="text"
                    id="highestValue"
                    placeholder="Highest Value"
                    value={highestValue}
                    onChange={(e) => setHighestValue(e.target.value)}
                    style={{ padding: '10px', borderRadius: '5px', border: '1px solid #ccc' }}
                />

                <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'flex-start', gap: '10px', marginLeft: '10px' }}>
                    <span style={{ fontWeight: 'bold' }}>Sensors:</span>
                    {Object.keys(enabledSensors).map((sensor) => (
                        <label key={sensor} style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                            <input
                                type="checkbox"
                                id={sensor}
                                checked={enabledSensors[sensor]}
                                onChange={() => handleSensorChange(sensor)}
                            />
                            {sensor.charAt(0).toUpperCase() + sensor.slice(1)}
                        </label>
                    ))}
                </div>

                <button type="submit" style={{ padding: '10px 20px', borderRadius: '5px', border: 'none', backgroundColor: '#007bff', color: 'white', cursor: 'pointer' }}>
                    Submit
                </button>
            </form>
        </div>
    );
};

export default Customize;
