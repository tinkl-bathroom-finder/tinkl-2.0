import React from "react";
import { BathroomType } from "../redux/types/BathroomType";

import {
  Accordion,
  AccordionDetails,
  AccordionSummary,
  Box,
  Typography,
} from "@mui/material";
import ExpandMore from "@mui/icons-material/ExpandMore";

import { stringifyDate } from "../modules/stringifyDate";

interface CommentsProps {
  bathroom: BathroomType
}

export const Comments: React.FC<CommentsProps> = ({ bathroom }) => {
  let commentArray = bathroom.comments

  return (
    <Accordion defaultExpanded sx={{ backgroundColor: '#D9D9D9', boxShadow: 'none' }} >
      <AccordionSummary
        expandIcon={<ExpandMore />}
        aria-controls="panel1-content"
        id="panel1-header"
        sx={{ paddingLeft: '0.5rem', margin: 0 }}
      >
        <Typography color="black" fontWeight="bold">Comments</Typography>
      </AccordionSummary>
      <Box sx={{ maxHeight: '25vh', overflowY: 'scroll' }}>
        {commentArray?.map((comment) => {
          return (
            <AccordionDetails key={comment.id}>
              <Box
                sx={{
                  pl: "8px",
                  justifyContent: "left",
                  mr: 2
                }}
              >
                <Typography sx={{ textAlign: 'left', color: 'darkgrey' }}>{stringifyDate(comment.inserted_at)}</Typography>
                <Typography variant='body1' color="black" sx={{ textAlign: 'left' }}>{comment.content}</Typography>
              </Box>
            </AccordionDetails>
          )
        })}
      </Box>
    </Accordion>)
}