import React, { useState } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { Box, Button, TextField } from '@mui/material';
import axios from 'axios';
import Swal from 'sweetalert2'
import { useNavigate } from "react-router-dom";

//Types
import { TinklRootState } from '../redux/types/TinklRootState';

export const ContactUs: React.FC = () => {
    const user = useSelector((state: TinklRootState) => state.user);
    const dispatch = useDispatch();
    const navigate = useNavigate();
    const [feedback, setFeedback] = useState<string>('')
    const api = import.meta.env.VITE_API_BASE_URL;

    const setFeedbackState = (text: string) => {
        setFeedback(text)
    }

    const submitFeedback = () => {
        if (feedback.length > 0) {
            axios
                .post(`${api}/contact`, { userId: user.id, feedback: feedback })
                .then(() => {
                    Swal.fire({
                        title: "Thank you!",
                        text: "Message received!",
                        icon: "success"
                    })
                    navigate("/");
                })
                .catch(() => {
                    Swal.fire({
                        title: "Oh no!",
                        text: "Something went wrong. Please try again later.",
                        icon: "error"
                    })
                })
        }
        // creates an alert if nothing is written
        else {
            Swal.fire({
                title: "Hey!!",
                text: "Please write a comment if you want to submit feedback!",
                icon: "warning"
            });
        }
    }

    return (
        <Box
            display="flex"
            flexDirection="column"
            justifyContent="center"
            alignItems="center"
            gap="2em"
            sx={{ mt: 3, mb: 3, width: '75vw' }}
        >
            {/* heading */}
            <h1>Contact Us!</h1>

            {/* textbox */}
            <TextField
                placeholder="Suggestions, comments, concerns..."
                multiline
                rows={6}
                fullWidth
                value={feedback}
                onChange={(event) => setFeedbackState(event.target.value)}
                variant="outlined"
            />
            {/* submit button */}
            <Button variant="contained" onClick={() => submitFeedback()}>
                Submit
            </Button>
        </Box>
    )
}